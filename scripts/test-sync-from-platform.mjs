import assert from 'node:assert/strict'
import { spawnSync } from 'node:child_process'
import { chmodSync, copyFileSync, existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { dirname, join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import test from 'node:test'

const script = resolve(dirname(fileURLToPath(import.meta.url)), '../sync-from-platform.sh')
const names = ['tiendu-docs', 'tiendu-theme', 'tiendu-meta-ads']
const internal = ['tiendu-bash']
const retired = ['tiendu-manager', 'tiendu-functions']
const run = (command, args, cwd) => spawnSync(command, args, { cwd, encoding: 'utf8' })
function git(cwd, ...args) {
	const result = run('git', args, cwd)
	assert.equal(result.status, 0, result.stderr)
	return result.stdout.trim()
}
function fixture(t) {
	const root = mkdtempSync(join(tmpdir(), 'publish-skills-test-'))
	t.after(() => rmSync(root, { recursive: true, force: true }))
	const repo = join(root, 'skills')
	const platform = join(root, 'platform')
	const source = join(platform, 'packages/skills')
	const remote = join(root, 'remote.git')
	mkdirSync(repo)
	git(root, 'init', '--bare', remote)
	git(repo, 'init', '--initial-branch=main')
	git(repo, 'config', 'user.email', 'skills-test@example.test')
	git(repo, 'config', 'user.name', 'Skills test')
	git(repo, 'remote', 'add', 'origin', remote)
	copyFileSync(script, join(repo, 'sync-from-platform.sh'))
	writeFileSync(join(repo, 'README.md'), 'Keep repository metadata\n')
	writeFileSync(join(repo, 'AGENTS.md'), 'Keep repository instructions\n')
	const config = {}
	for (const name of [...names, ...internal]) {
		config[name] = { manu: true, public: names.includes(name), docs: false }
		mkdirSync(join(source, name, 'references'), { recursive: true })
		writeFileSync(join(source, name, 'SKILL.md'), `Current ${name}\n`)
		writeFileSync(join(source, name, 'references/current.md'), 'Current reference\n')
		writeFileSync(join(source, name, 'references/manu.md'), 'Manu-only\n')
	}
	writeFileSync(join(source, 'skills.config.json'), JSON.stringify(config))
	for (const name of [...names, ...internal, ...retired]) {
		mkdirSync(join(repo, name), { recursive: true })
		writeFileSync(join(repo, name, 'SKILL.md'), `Old ${name}\n`)
		writeFileSync(join(repo, name, 'obsolete.md'), 'Remove this file\n')
	}
	git(repo, 'add', '.')
	git(repo, 'commit', '-m', 'Initial fixture')
	git(repo, 'push', '-u', 'origin', 'main')
	return { repo, source, remote, publish: (...args) => run('bash', [join(repo, 'sync-from-platform.sh'), '--platform', platform, ...args], root) }
}

test('publishing exports the public skills without manu.md, removes retired skills, and pushes', t => {
	const f = fixture(t)
	const before = git(f.repo, 'rev-parse', 'HEAD')
	const result = f.publish()
	assert.equal(result.status, 0, result.stderr)
	for (const name of names) {
		assert.equal(readFileSync(join(f.repo, name, 'SKILL.md'), 'utf8'), `Current ${name}\n`)
		assert.equal(existsSync(join(f.repo, name, 'obsolete.md')), false)
		assert.equal(existsSync(join(f.repo, name, 'references/manu.md')), false)
		assert.equal(readFileSync(join(f.repo, name, 'references/current.md'), 'utf8'), 'Current reference\n')
	}
	for (const name of [...internal, ...retired]) assert.equal(existsSync(join(f.repo, name)), false)
	assert.equal(git(f.repo, 'ls-files', ...internal, ...retired), '')
	assert.equal(readFileSync(join(f.repo, 'README.md'), 'utf8'), 'Keep repository metadata\n')
	assert.equal(readFileSync(join(f.repo, 'AGENTS.md'), 'utf8'), 'Keep repository instructions\n')
	assert.equal(git(f.repo, 'ls-files', 'AGENTS.md', 'sync-from-platform.sh'), 'AGENTS.md\nsync-from-platform.sh')
	assert.equal(git(f.repo, 'status', '--porcelain'), '')
	const after = git(f.repo, 'rev-parse', 'HEAD')
	assert.notEqual(after, before)
	assert.equal(git(f.remote, 'rev-parse', 'main'), after)
	assert.equal(f.publish().status, 0)
	assert.equal(git(f.repo, 'rev-parse', 'HEAD'), after)
})

test('copy-only exports for review without committing or needing a remote', t => {
	const f = fixture(t)
	const before = git(f.repo, 'rev-parse', 'HEAD')
	git(f.repo, 'remote', 'remove', 'origin')
	writeFileSync(join(f.repo, 'README.md'), 'Unrelated local edit\n')
	assert.equal(f.publish('--copy-only').status, 0)
	assert.equal(git(f.repo, 'rev-parse', 'HEAD'), before)
	assert.equal(readFileSync(join(f.repo, 'tiendu-theme/SKILL.md'), 'utf8'), 'Current tiendu-theme\n')
	assert.equal(readFileSync(join(f.repo, 'README.md'), 'utf8'), 'Unrelated local edit\n')
})

test('a dirty publishing checkout is preserved before any files are copied', t => {
	const f = fixture(t)
	writeFileSync(join(f.repo, 'tiendu-theme/SKILL.md'), 'Local work to preserve\n')
	const result = f.publish()
	assert.notEqual(result.status, 0)
	assert.match(result.stderr, /local changes/)
	assert.equal(readFileSync(join(f.repo, 'tiendu-theme/SKILL.md'), 'utf8'), 'Local work to preserve\n')
})

test('all source skills are validated before beginning an export', t => {
	const f = fixture(t)
	rmSync(join(f.source, 'tiendu-meta-ads'), { recursive: true })
	const result = f.publish()
	assert.notEqual(result.status, 0)
	assert.equal(readFileSync(join(f.repo, 'tiendu-theme/SKILL.md'), 'utf8'), 'Old tiendu-theme\n')
	assert.equal(git(f.repo, 'status', '--porcelain'), '')
})

test('a rejected push keeps the export commit and can be retried', t => {
	const f = fixture(t)
	const before = git(f.repo, 'rev-parse', 'HEAD')
	const hook = join(f.remote, 'hooks/pre-receive')
	writeFileSync(hook, '#!/bin/sh\nexit 1\n')
	chmodSync(hook, 0o755)
	assert.notEqual(f.publish().status, 0)
	const exported = git(f.repo, 'rev-parse', 'HEAD')
	assert.notEqual(exported, before)
	assert.equal(git(f.remote, 'rev-parse', 'main'), before)
	rmSync(hook)
	assert.equal(f.publish().status, 0)
	assert.equal(git(f.repo, 'rev-parse', 'HEAD'), exported)
	assert.equal(git(f.remote, 'rev-parse', 'main'), exported)
})

---
title: Collaborators
description: Invite and manage store collaborators through Merchant API v3.
---

Concepts and workflows: [Team](../../store-settings/team.md). For authentication, requests and errors, see [REST API](../overview.md).

## Operations

| Operation | Method | Path |
| --- | --- | --- |
| [List collaborators](list.md) | `GET` | `/collaborators` |
| [Create a collaborator](create.md) | `POST` | `/collaborators` |
| [Get a collaborator](get.md) | `GET` | `/collaborators/{collaboratorId}` |
| [Update a collaborator](update.md) | `PATCH` | `/collaborators/{collaboratorId}` |
| [Delete a collaborator](delete.md) | `DELETE` | `/collaborators/{collaboratorId}` |

- [Collaborator object](object.md)

## API behavior

Responses include contact details and `isOwner`, and omit internal administrative fields. Existing owners cannot be edited or removed through this API.

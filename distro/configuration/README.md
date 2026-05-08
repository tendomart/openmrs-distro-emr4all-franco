# OpenMRS Configuration (Initializer)

This directory is overlaid onto `openmrs_config/configuration/` in the backend
image (see the project `Dockerfile`). It is loaded on startup by the
[Initializer](https://github.com/mekomsolutions/openmrs-module-initializer) module.

## Layout

```
configuration/
├── encountertypes/
│   └── encountertypes.csv        # Encounter types referenced by forms
└── forms/
    └── malaria_consultation_form_o3.json
```

## Bundled forms

| File | Encounter Type | Encounter Type UUID |
| --- | --- | --- |
| `forms/malaria_consultation_form_o3.json` | Malaria Consultation | `e22e39fd-7db2-45e7-80f1-60fa0d5a4378` |

## Adding an O3 (JSON) form

1. Drop a new file under `forms/` named `<your_form>.json`.
2. Make sure the JSON has a unique `uuid` and `name`.
3. Reference an `encounterType` UUID that already exists, or add it to
   `encountertypes/encountertypes.csv` so Initializer creates it on startup.
4. Rebuild the backend image: `./manage-containers.sh` -> option `2` (rebuild).
5. After startup, find the form at `/openmrs/spa/form-builder` or render it in
   a workspace via `@openmrs/esm-form-engine-app`.

The Initializer detects file extension:

- `*.json` -> loaded via the `o3forms` module
- `*.xml`  -> loaded as legacy HTML Form

## Other domains

You can add sibling folders for other Initializer domains, e.g.:

- `concepts/` (CSV)
- `globalproperties/` (XML)
- `roles/`, `privileges/`, etc.

See the Initializer docs for the full list.

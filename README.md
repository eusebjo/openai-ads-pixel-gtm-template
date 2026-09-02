# OpenAI Ads Measurement Pixel GTM Template — Enhanced Fork

This repository is an enhanced fork of OpenAI's official Google Tag Manager web
tag template. It installs and configures the OpenAI Ads Measurement Pixel without
Custom HTML and keeps the SDK URL and global API locked behind narrow GTM
template permissions.

The fork adds:

- Google Consent Mode synchronization for `ad_storage` and `ad_user_data`, plus
  an optional strict mode that keeps the SDK off the page until consent is
  granted and then replays the event;
- all nine documented user-matching fields, with optional in-browser
  normalization and SHA-256 hashing so raw values never leave the page;
- manual or variable-driven `contents` arrays;
- explicit `measure` / `measureSingle` targeting for multi-pixel pages;
- per-page Pixel initialization deduplication and late `init({user})` support;
- validation aligned with the SDK's own rules for currency, monetary integers,
  custom event names, contents, and identifier hashes;
- 18 GTM sandbox test scenarios.

This fork is not an official OpenAI release. The upstream source is
[openai/ads-measurement-pixel-gtm-template](https://github.com/openai/ads-measurement-pixel-gtm-template).

## Coverage of the Pixel surface

Checked against the OpenAI documentation and against the shipped SDK build
(`oaiq.min.js`, `0.1.32`), which is the authority on what is actually accepted.

| Pixel capability | Upstream template | This fork |
| --- | --- | --- |
| `init` with `pixelId` and `debug` | Yes | Yes, debug also automatic in GTM Preview |
| `consent` command | No | Yes, driven by Consent Mode, with a no-storage-before-consent mode |
| `measure` | Yes | Yes |
| `measureSingle` | No | Yes, automatic or forced |
| 11 web event names | Yes | Yes |
| `app_installed`, `app_opened` excluded (Conversions API only) | Yes | Yes, and both are reserved against reuse as a custom event name |
| `contents`, `customer_action`, `plan_enrollment`, `custom` shapes | Yes | Yes |
| `plan_id` on `plan_enrollment` and `custom` | Partial | Yes |
| `contents[]` on `contents`, `plan_enrollment` and `custom` | Partial | Yes |
| `contents[]` restricted to the six Pixel-supported keys | Yes | Yes, `group_id` and `variant_dict` stay Conversions-API-only |
| `contents[]` from a GTM variable | No | Yes |
| `event_id`, `custom_event_name`, `opt_out` | Yes | Yes |
| `custom_event_name` rules | Partial | Yes, including the SDK's lowercase-only rule |
| `user` identifier fields | 3 of 5 | 5 of 5 |
| `user` location fields | `country`, `city`, `zip_code` | `country`, `city`, `region`, `postal_code` |
| Raw identifiers normalized and hashed in the browser | No | Yes, optional |
| One `init` per Pixel ID per page, late `init({user})` | No | Yes |
| Automatic advanced matching, `oppref`, `source_url`, batching | Handled by the SDK | Handled by the SDK |

`measure`, `measureSingle`, `init` and `consent` are the only commands the SDK
dispatches, so the command surface is fully covered.

## Install

1. In Google Tag Manager, open **Templates**.
2. Under **Tag Templates**, select **New**.
3. Open the overflow menu and select **Import**.
4. Choose `template.tpl` from this repository.
5. Review the requested permissions and save the template.

The template requests only the permissions required to load the fixed OpenAI
SDK URL, use the `oaiq` queue, read container debug state, read consent state,
listen for consent updates, and retain per-page template state.

## Recommended configuration

Create one tag for every event boundary you want to measure and use the same
Pixel ID in all tags.

1. Enter the Pixel ID supplied by OpenAI Ads Manager.
2. Keep **Respect Google Consent Mode** enabled when Consent Mode is used.
3. Enable **Send a measurement event when this tag fires**.
4. Select an event and configure its applicable values.
5. Attach a trigger that fires only after the real action succeeds.

An optional base tag can initialize the Pixel without sending an event. Disable
event sending and attach an Initialization or All Pages trigger. Event tags can
also initialize the Pixel themselves, and this fork prevents duplicate
`init({pixelId})` calls for the same Pixel ID on a page.

If a page initializes more than one Pixel ID, late user-data updates are
explicitly targeted to the intended Pixel ID as required by the OpenAI multiple
pixels guidance.

**Send the event to** controls which pixels receive the event:

| Option | Behaviour |
| --- | --- |
| Automatic (default) | `measure` while the page runs a single Pixel ID, `measureSingle` once this template has initialized more than one. |
| This Pixel ID only | Always `measureSingle`, addressed to the Pixel ID in this tag. |
| Every initialized Pixel ID | Always `measure`, which the SDK broadcasts to every Pixel ID initialized so far. |

Do not use a button click as the trigger when it only represents an attempt.
For example, fire `order_created` after the order is confirmed and
`registration_completed` after account creation succeeds.

## Supported browser events

The template exposes the documented web Pixel events:

- content and commerce: `page_viewed`, `contents_viewed`, `items_added`,
  `checkout_started`, `order_created`;
- customer actions: `lead_created`, `registration_completed`,
  `appointment_scheduled`;
- plan enrollment: `subscription_created`, `trial_started`;
- fallback: `custom`, with a valid `custom_event_name`.

Native-app-only events such as `app_installed` and `app_opened` are not exposed
because this is a GTM web template.

## Event data

All monetary amounts are integers in the currency's minor unit. For example,
EUR 25.99 is `2599`, not `25.99`. Currency values must be three-letter codes
such as `EUR` or `USD`.

For content events, choose either a manual table or a GTM variable. A dynamic
variable must resolve to an array of objects using documented keys:

```javascript
[
  {
    id: "sku_123",
    name: "Example product",
    content_type: "product",
    quantity: 1,
    amount: 2599,
    currency: "EUR"
  }
]
```

`event_id` is optional for Pixel-only tracking. When the same conversion is sent
through Pixel and Conversions API, pass the same stable ID to both sides to
enable deduplication.

## Consent

With **Respect Google Consent Mode** enabled, the tag sends the current
`ad_storage` value through `oaiq("consent", ...)` before Pixel initialization and
keeps it synchronized when consent changes. Configured user-matching data is
sent only when `ad_user_data` is granted.

**When `ad_storage` is denied** selects one of two behaviours:

| Option | Behaviour |
| --- | --- |
| Load the SDK and set OpenAI consent to false (default) | Matches the documented OpenAI pattern. The SDK loads, sends no measurement pings, and writes its own `__oaiq_consent` cookie and local storage entry. Events fired while consent is denied are lost, because the SDK does not replay blocked events. |
| Do not load the SDK, then send the event once consent is granted | The SDK is never injected while consent is denied, so no OpenAI cookie or local storage is written before consent. The tag registers a consent listener and replays its own event when `ad_storage` becomes granted. |

Choose the second option for sites that must write no vendor storage before
consent, which is the usual expectation under the ePrivacy Directive as
implemented in the EU.

Important: GTM treats an unset consent type as granted. Your CMP or Consent Mode
template must therefore establish the default consent state before this tag
runs.

The event-level `opt_out` option is a personalization opt-out. It is not a
replacement for measurement consent.

## User matching

The template supports every documented field: `email_sha256`,
`phone_number_sha256`, `external_id_sha256`, `first_name_sha256`,
`last_name_sha256`, `country`, `city`, `region`, and `postal_code`.

Each identifier field accepts either a 64-character hexadecimal SHA-256 digest,
which is passed through unchanged, or a raw value. With **Normalize and SHA-256
hash raw identifiers in the browser** enabled, a raw value is normalized
following the OpenAI rules and hashed with the browser Web Crypto API before it
is handed to the SDK, so no raw identifier is ever transmitted:

| Field | Normalization applied before hashing |
| --- | --- |
| Email | Trim whitespace, lowercase |
| Phone number | Keep the country code and digits only, drop a leading `+` and leading zeroes, expect 8 to 15 digits |
| External ID | Trim whitespace, preserve case and every other character |
| First name, last name | Lowercase, remove whitespace and ASCII punctuation, preserve accents |

Clear the checkbox to reject anything that is not already a digest, which
reproduces the stricter behaviour of earlier versions of this fork. If the
browser has no Web Crypto SHA-256, the affected identifier is dropped and the
conversion is still sent.

Review your legal basis and consent requirements before enabling any matching
field.

## Debugging and QA

Debug mode is enabled automatically in GTM Preview/Debug. Keep the manual debug
checkbox disabled in published containers unless OpenAI Ads support asks you to
enable diagnostics.

Before publishing:

1. Run every scenario in the template editor's **Tests** tab.
2. Preview the container and verify the tag fires once at the intended success
   boundary.
3. Check that the loader request uses
   `https://bzrcdn.openai.com/sdk/oaiq.min.js`.
4. Validate consent-denied and consent-granted paths separately.
5. Confirm that no raw identifier leaves the browser: with in-browser hashing
   enabled, the network payload must contain only 64-character digests.
6. Confirm CSP permits the OpenAI CDN and any documented collection endpoints.
7. Validate the event in Ads Manager before publishing the container.

## Community Template Gallery publication

Before publishing this fork to the GTM Community Template Gallery:

- replace upstream branding only with assets and names you are authorized to use;
- point `homepage` and `documentation` in `metadata.yaml` to your maintained fork;
- commit the final `template.tpl`, then replace the metadata version SHA with
  that exact commit SHA;
- follow Google's template style, permission, testing, and gallery policies;
- do not present this enhanced fork as an official OpenAI-maintained template.

The current `metadata.yaml` intentionally preserves the upstream provenance and
is not ready to identify a separately published fork.

## Sources

- [OpenAI Ads Measurement Pixel](https://developers.openai.com/ads/measurement-pixel)
- [OpenAI Ads supported events](https://developers.openai.com/ads/supported-events)
- [OpenAI Ads multiple pixels](https://developers.openai.com/ads/multiple-pixels)
- [Google custom templates guide](https://developers.google.com/tag-platform/tag-manager/templates)
- [Google template APIs](https://developers.google.com/tag-platform/tag-manager/templates/api)
- [Google permissions reference](https://developers.google.com/tag-platform/tag-manager/templates/permissions)
- [Google Community Template Gallery](https://developers.google.com/tag-platform/tag-manager/templates/gallery)

## Security

To report a security issue, follow [SECURITY.md](SECURITY.md).

## License

Copyright 2026 OpenAI

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

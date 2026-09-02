# OpenAI Ads Measurement Pixel GTM Template, enhanced fork

Community-maintained fork of OpenAI's Google Tag Manager web tag template for
the OpenAI Ads Measurement Pixel. It installs and configures the Pixel without
Custom HTML and keeps the SDK URL and the `oaiq` global locked behind narrow GTM
template permissions.

This fork is not an official OpenAI release. Upstream source:
[openai/ads-measurement-pixel-gtm-template](https://github.com/openai/ads-measurement-pixel-gtm-template).

What the fork adds:

- User consent always respected. While consent is denied the SDK is not loaded,
  so OpenAI writes no cookie and receives no request. Consent is read from the
  GTM consent state that every CMP feeds (the event is then sent once
  `ad_storage` is granted, and user matching data once `ad_user_data` is
  granted, even after the tag fired) or from a GTM variable for CMPs that are
  not integrated with GTM consent.
- All nine documented user matching fields, with optional in-browser
  normalization and SHA-256 hashing. A field that cannot be sent is skipped and
  logged in Preview; it never blocks the conversion.
- `contents` from a manual table or from a GTM variable. An empty variable sends
  the event without contents.
- Explicit `measure` / `measureSingle` targeting for pages with several Pixel IDs,
  and late user data updates always addressed to the configured Pixel ID.
- One `init` per Pixel ID per page, with debug and user data updates on repeated
  fires.
- Custom event names lowercased before sending, because Ads Manager registers
  custom event names in lowercase only.
- Validation aligned with the SDK build (`oaiq.min.js` 0.1.32) for currency,
  monetary integers, contents and identifier digests.
- 25 GTM sandbox test scenarios.

## Coverage of the Pixel surface

Checked against the OpenAI documentation and against the shipped SDK build,
which is the authority on what is actually accepted.

| Pixel capability | Upstream template | This fork |
| --- | --- | --- |
| `init` with `pixelId` and `debug` | Yes | Yes, debug also automatic in GTM Preview and re-sent on repeated fires |
| `consent` command | No | Yes, driven by the GTM consent state or a GTM variable; the SDK is never loaded while consent is denied |
| `measure` | Yes | Yes |
| `measureSingle` | No | Yes, automatic or forced |
| 11 web event names | Yes | Yes |
| `app_installed`, `app_opened` excluded (Conversions API only) | Yes | Yes, and both are reserved against reuse as a custom event name (template policy, the SDK reserves only the 11 web names) |
| `contents`, `customer_action`, `plan_enrollment`, `custom` shapes | Yes | Yes |
| `plan_id` on `plan_enrollment` and `custom` | Yes | Yes |
| `contents[]` on `contents`, `plan_enrollment` and `custom` | Yes | Yes |
| `contents[]` restricted to the six Pixel-supported keys | Yes | Yes, `group_id` and `variant_dict` stay Conversions-API-only |
| `contents[]` from a GTM variable | No | Yes |
| `event_id`, `custom_event_name`, `opt_out` | Yes | Yes |
| `custom_event_name` rules | Non-empty only | Documented rules, lowercased before sending |
| `user` identifier fields | 2 of 5 (`email_sha256`, `external_id_sha256`) | 5 of 5 |
| `user` location fields | `country`, `city`, `zip_code` | `country`, `city`, `region`, `postal_code` |
| Raw identifiers hashed before they reach the page-global `oaiq` queue | No, raw values were handed to the SDK, which hashes them itself (undocumented) | Yes, optional |
| One `init` per Pixel ID, late `init({pixelId, user})` | No | Yes |
| Automatic advanced matching, `oppref`, `source_url`, batching | Handled by the SDK | Handled by the SDK |

The SDK dispatches only `init` (alias `initialize`), `consent`, `measure` and
`measureSingle`, so the command surface is fully covered.

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
2. Leave **Consent source** on the GTM consent state when a CMP feeds it, or select the GTM variable that reflects your CMP's choice.
3. Enable **Send a measurement event when this tag fires**.
4. Select an event and configure its applicable values.
5. Attach a trigger that fires only after the real action succeeds.

Every tag loads the SDK and initializes the Pixel before sending its event, so a
separate base tag is not required; the template prevents duplicate
`init({pixelId})` calls for the same Pixel ID on a page. The Pixel must still run
on every page, not only on conversion pages: the SDK reads the click identifier
`oppref` from the landing page URL and stores it in the `__oppref` cookie, and a
conversion can only be attributed if that happened. A `page_viewed` tag on All
Pages covers this and measures the visit; a tag with event sending disabled
initializes the Pixel without measuring anything.

Do not use a button click as the trigger when it only represents an attempt.
Fire `order_created` after the order is confirmed and `registration_completed`
after account creation succeeds.

### Pages with more than one Pixel ID

**Send the event to** controls which pixels receive the event:

| Option | Behaviour |
| --- | --- |
| Automatic (default) | `measure` while this template has initialized a single Pixel ID, `measureSingle` once it has initialized more than one. |
| This Pixel ID only | Always `measureSingle`, addressed to the Pixel ID in this tag. |
| Every initialized Pixel ID | Always `measure`, which the SDK broadcasts to every Pixel ID initialized on the page, including pixels initialized outside GTM. |

The automatic option counts only pixels initialized by this template. When the
page also runs a hardcoded Pixel of another advertiser, choose **This Pixel ID
only**. Late user data updates always include the Pixel ID, so they cannot land
on a pixel initialized elsewhere.

## Supported browser events

- content and commerce: `page_viewed`, `contents_viewed`, `items_added`,
  `checkout_started`, `order_created`;
- customer actions: `lead_created`, `registration_completed`,
  `appointment_scheduled`;
- plan enrollment: `subscription_created`, `trial_started`;
- fallback: `custom`, with a `custom_event_name`.

`app_installed` and `app_opened` are Conversions API only and are not exposed.

### Custom event names

A custom event is attributed to the conversion registered in Ads Manager with
the same `custom_event_name`. Ads Manager accepts lowercase names only, so the
template lowercases the configured value before validating and sending it, and
logs the change in Preview. The documented rules then apply: 1 to 64
characters, letters, numbers, underscores or hyphens, first and last character
alphanumeric, not a standard event name. The display name of the conversion in
Ads Manager is never transmitted.

If the same conversion is also sent through the Conversions API, keep
`custom_event_name` and `event_id` identical on both sides; deduplication
matches on Pixel ID, event name and `event_id`.

## Event data

All monetary amounts are integers in the currency's minor unit: EUR 25.99 is
`2599`. Currency values are three-letter ISO 4217 codes such as `EUR`.

For content events, choose a manual table or a GTM variable. A variable must
resolve to an array of objects using the documented keys; other keys are
ignored, and an empty or undefined variable sends the event without contents:

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

## Consent

The rule is fixed: while the user has not consented, the SDK is not loaded, so
OpenAI writes no cookie or local storage entry, receives no request, and no
event is sent. The **Consent source** setting only chooses where the tag reads
consent.

| Consent source | How consent is read | While denied | When granted later |
| --- | --- | --- | --- |
| GTM consent state (default) | `ad_storage` for measurement, `ad_user_data` for user matching, as set by your CMP through GTM consent | Nothing is loaded; the tag registers a listener and reports success | The tag loads the SDK and sends its event; user matching data is sent with a targeted `init` once `ad_user_data` is granted |
| GTM variable | A variable that resolves to `true`, `"true"` or `"granted"`; the same value gates user matching | Nothing is loaded; the tag reports success | No notification exists for variables, so fire the tag again on the CMP's consent event |
| Not managed by this tag | Always granted | n/a | n/a |

The GTM consent state is a Google API name, but it is the standard channel
through which iubenda, Cookiebot, OneTrust, Usercentrics and the other CMPs
signal consent to tags, and the only one that notifies changes. Two facts
matter when using it:

- GTM treats a consent type that was never set as granted. The CMP must set
  the defaults before this tag runs, usually on the Consent Initialization
  trigger. On a site without any consent signal the tag behaves as if consent
  were granted.
- GTM allows one completion callback per tag, so a waiting tag reports success
  when it starts waiting; a later SDK load failure is not reported.

Once consent is granted the template sends `oaiq("consent", true)` once per
page, which clears a denial the SDK may have stored on an earlier visit, and
with the GTM consent state forwards a later revocation as
`oaiq("consent", false)` so the SDK stops sending. That revocation command
makes the SDK store the denial in its `__oaiq_consent` cookie and local
storage entry.

Why the SDK is never loaded while denied: OpenAI documents a single consent
mechanism, `oaiq("consent", false)` before `init`. With consent `false` the
SDK measures nothing and offers no modelled or cookieless mode comparable to
Google's advanced Consent Mode, yet it still writes its consent cookie and, as
far as the SDK source shows, sends a first-visit diagnostic request. Loading it
before consent therefore has costs and no benefit, and the documented image-tag
variant of the Pixel itself says to render nothing before consent.

The event-level `opt_out` option is a personalization opt-out, not a
replacement for measurement consent.

## User matching

The template supports every documented field: `email_sha256`,
`phone_number_sha256`, `external_id_sha256`, `first_name_sha256`,
`last_name_sha256`, `country`, `city`, `region`, and `postal_code`. Tags created
with the upstream template keep working: the old `zipCode` value is read as the
postal code when the new field is empty.

Each identifier field accepts either a 64-character hexadecimal SHA-256 digest,
which is passed through in lowercase, or a raw value. With **Normalize and
SHA-256 hash raw identifiers in the browser** enabled, a raw value is normalized
following the OpenAI rules and hashed with the browser Web Crypto API before it
is handed to the SDK:

| Field | Normalization applied before hashing |
| --- | --- |
| Email | Trim whitespace, lowercase |
| Phone number | Keep the country code and digits only, drop a leading `+` and leading zeroes, expect 8 to 15 digits |
| External ID | Trim whitespace, preserve case and every other character |
| First name, last name | Lowercase, remove whitespace (including Unicode spaces) and ASCII punctuation, preserve accents |

The current SDK build also hashes raw values on its own, although the
documentation says never to send them. Hashing in the template is therefore a
defence in depth: the raw value never enters the page-global `oaiq` queue,
which any other script on the page can read.

Clear the checkbox to skip any identifier that is not already a digest. In every
case a field that cannot be sent (invalid country code, city or region over 128
characters, postal code with characters other than letters, digits, spaces and
hyphens, phone outside 8 to 15 digits, browser without Web Crypto) is dropped
with a Preview log and the conversion is still sent.

Review your legal basis and consent requirements before enabling any matching
field.

## Debugging and QA

The OpenAI SDK debug flag is set automatically in GTM Preview/Debug and can be
forced with **Enable setup diagnostics in the browser console**; the SDK then
logs to the console also in a published container, on the first and on repeated
inits. The template's own validation messages use the GTM logging permission,
which is restricted to Preview/Debug, so a misconfigured tag in a published
container fails silently: run every new tag through Preview first.

Before publishing:

1. Run every scenario in the template editor's **Tests** tab.
2. Preview the container and verify the tag fires once at the intended success
   boundary.
3. Check that the loader request uses
   `https://bzrcdn.openai.com/sdk/oaiq.min.js`.
4. Validate consent-denied and consent-granted paths separately, including a
   grant given after the page loaded: while denied, no request to
   `bzrcdn.openai.com` or `bzr.openai.com` and no `__oaiq_consent` cookie may
   appear.
5. Confirm that no raw identifier leaves the browser: the network payload must
   contain only 64-character digests.
6. Confirm CSP permits `https://bzrcdn.openai.com` (script and connect) and
   `https://bzr.openai.com` (connect and img).
7. Confirm the events reach OpenAI with the Ads API "recent events" endpoint of
   the conversion setup reference, or wait for them in Ads Manager.

## Community Template Gallery publication

Before submitting this fork to the GTM Community Template Gallery:

- commit the final `template.tpl`, then set the version SHA in `metadata.yaml`
  to that exact commit;
- keep `homepage` and `documentation` in `metadata.yaml` pointing to the
  maintained fork;
- follow Google's template style, permission, testing and gallery policies;
- do not present the fork as an official OpenAI-maintained template.

## Sources

- [OpenAI Ads Measurement Pixel](https://developers.openai.com/ads/measurement-pixel)
- [OpenAI Ads supported events](https://developers.openai.com/ads/supported-events)
- [OpenAI Ads multiple pixels](https://developers.openai.com/ads/multiple-pixels)
- [OpenAI Ads conversion setup API](https://developers.openai.com/ads/api-reference/conversion-setup)
- [Google custom templates guide](https://developers.google.com/tag-platform/tag-manager/templates)
- [Google template APIs](https://developers.google.com/tag-platform/tag-manager/templates/api)
- [Google permissions reference](https://developers.google.com/tag-platform/tag-manager/templates/permissions)
- [Google Community Template Gallery](https://developers.google.com/tag-platform/tag-manager/templates/gallery)

## Maintainer

This fork is maintained by [eusebjo](https://github.com/eusebjo).
For questions, bug reports and feature requests open an issue on
[this repository](https://github.com/eusebjo/openai-ads-pixel-gtm-template/issues).
OpenAI does not maintain or support this template; for the Pixel itself, use
the OpenAI Ads documentation and support channels.

## Security

For vulnerabilities in the OpenAI Pixel SDK, follow OpenAI's
[Coordinated Vulnerability Disclosure Policy](https://openai.com/policies/coordinated-vulnerability-disclosure-policy).
For issues in this template, see [SECURITY.md](SECURITY.md).

## License

Apache 2.0, see [LICENSE](LICENSE). Upstream copyright OpenAI.

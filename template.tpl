___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community Template Gallery Developer Terms of Service available at https://developers.google.com/tag-manager/gallery-tos (or such other URL as Google may provide), as modified from time to time.

___INFO___

{
  "type": "TAG",
  "id": "cvt_eusebjo_openai_ads_pixel",
  "version": 1,
  "categories": ["ADVERTISING", "CONVERSIONS"],
  "displayName": "OpenAI Ads Measurement Pixel (Enhanced)",
  "brand": {
    "id": "eusebjo",
    "displayName": "eusebjo",
    "thumbnail": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAYAAADimHc4AAABg0lEQVR42u3dQW7DMAwEQL6nyP+/15x6axMHqMmVNAF4TY0dG3Upia3H46su1rf6qC7lKvhhCMEPQwh/GEH4wwjCH0YQ/jACgBAAgQwhAAgAEMRgAQAAQBAAACgAABQAAAoAgNi6+gHQHPjKILVz8CtA1AnBJ0PUScEnQtRK4U9+53YAXQGlQ1Rq+Dv8zEiA6RDSEOqk8BMRIgDSfg9tCZD6FjJ9XXVy+AnXB2B3gFX6MlPXOQKwUvd1aYDuv25XfApqlTuqq9G2DcB/BtPZ7ex+Cir97p9oOQMYXpIEcMMizVEASXd/+lMAAEDmrggAAAAAAAAAAACvoQAAaEVoxmnGaUdbkLEgY0nSorxFedtSbMyyMcvWRAAAbE93QMMBDUeUHNJzSM8xVQe1HdQ2qsCwDsM6jKsxsMnAJiPLDO0ztE8BAKAAAFAAACgAABQAAOoVAIS58t9UUwAgDIQPIAwAQnP4vwFAaAz/LwAITeG/AoDQEP47ABA3Bv8JAIgbgv+pJzYcn/212yR+AAAAAElFTkSuQmCC"
  },
  "description": "Community-maintained enhanced fork. Loads the OpenAI Ads Measurement Pixel SDK and sends consent-aware page view or conversion events without custom HTML, with Google Consent Mode integration and full user matching.",
  "containerContexts": ["WEB"],
  "securityGroups": []
}

___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "pixelSettings",
    "displayName": "Pixel setup",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "TEXT",
        "name": "pixelId",
        "displayName": "Pixel ID",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "help": "Paste the Pixel ID from OpenAI Ads. Example: px_123.",
        "alwaysInSummary": true
      },
      {
        "type": "CHECKBOX",
        "name": "sendEvent",
        "checkboxText": "Send a measurement event when this tag fires",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "Leave checked for page view and conversion tags. Clear this for a base tag that only loads and initializes the pixel."
      },
      {
        "type": "CHECKBOX",
        "name": "enableDebug",
        "checkboxText": "Enable setup diagnostics in the browser console",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "Passes debug: true to the OpenAI SDK, which then logs its own activity in the browser console, also in a published container. Enabled automatically in GTM Preview/Debug mode. The template's own validation messages are visible only in GTM Preview/Debug."
      },
      {
        "type": "CHECKBOX",
        "name": "respectGtmConsent",
        "checkboxText": "Respect Google Consent Mode",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "Recommended. Synchronizes OpenAI measurement consent with ad_storage and sends configured user matching data only when ad_user_data is granted, at tag time or as soon as it is granted later on the page. GTM treats a consent type that was never set as granted, so your CMP must set Consent Mode defaults before this tag runs; without Consent Mode the tag behaves as if consent were granted."
      },
      {
        "type": "SELECT",
        "name": "consentMode",
        "displayName": "When ad_storage is denied",
        "selectItems": [
          {
            "value": "defer",
            "displayValue": "Do not load the SDK, send the event once consent is granted (recommended)"
          },
          {
            "value": "signal",
            "displayValue": "Load the SDK and set OpenAI consent to false, events are discarded"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "defer",
        "enablingConditions": [
          {
            "paramName": "respectGtmConsent",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "help": "Default: while ad_storage is denied the SDK is not loaded, so OpenAI writes no cookie and receives no request; the tag waits and sends its event once consent is granted. GTM allows one completion callback per tag, so the tag reports success as soon as it starts waiting. Alternative: the documented OpenAI pattern loads the SDK and calls oaiq(\"consent\", false); the SDK then writes its __oaiq_consent cookie and local storage entry, still sends a first-visit diagnostic request, and discards events fired while consent is denied without replaying them."
      },
      {
        "type": "SELECT",
        "name": "pixelTargeting",
        "displayName": "Send the event to",
        "selectItems": [
          {
            "value": "auto",
            "displayValue": "Automatic (this Pixel ID only when this template runs more than one)"
          },
          {
            "value": "single",
            "displayValue": "This Pixel ID only (measureSingle)"
          },
          {
            "value": "all",
            "displayValue": "Every initialized Pixel ID (measure)"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "auto",
        "enablingConditions": [
          {
            "paramName": "sendEvent",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "help": "measure sends to every Pixel ID initialized on the page so far, including pixels initialized outside GTM. measureSingle sends only to the Pixel ID configured in this tag. Automatic uses measure while this template has initialized a single Pixel ID and switches to measureSingle once it has initialized more than one; pixels initialized outside this template are not counted, so choose the second option when the page also runs a hardcoded pixel of another advertiser."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "eventSettings",
    "displayName": "Event",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "sendEvent",
        "paramValue": true,
        "type": "EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "SELECT",
        "name": "eventName",
        "displayName": "Event name",
        "simpleValueType": true,
        "defaultValue": "page_viewed",
        "alwaysInSummary": true,
        "selectItems": [
          {
            "value": "page_viewed",
            "displayValue": "Page viewed"
          },
          {
            "value": "contents_viewed",
            "displayValue": "Contents viewed"
          },
          {
            "value": "items_added",
            "displayValue": "Items added"
          },
          {
            "value": "checkout_started",
            "displayValue": "Checkout started"
          },
          {
            "value": "order_created",
            "displayValue": "Order created"
          },
          {
            "value": "lead_created",
            "displayValue": "Lead created"
          },
          {
            "value": "registration_completed",
            "displayValue": "Registration completed"
          },
          {
            "value": "appointment_scheduled",
            "displayValue": "Appointment scheduled"
          },
          {
            "value": "trial_started",
            "displayValue": "Trial started"
          },
          {
            "value": "subscription_created",
            "displayValue": "Subscription created"
          },
          {
            "value": "custom",
            "displayValue": "Custom event"
          }
        ],
        "help": "Choose the business event that matches the page or conversion action."
      },
      {
        "type": "TEXT",
        "name": "customEventName",
        "displayName": "Custom event name",
        "simpleValueType": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "enablingConditions": [
          {
            "paramName": "eventName",
            "paramValue": "custom",
            "type": "EQUALS"
          }
        ],
        "help": "Required only for Custom event. Must be the custom event name registered in Ads Manager, which accepts only lowercase names, so the value is lowercased before it is sent. Rules: 1 to 64 characters, letters, numbers, underscores or hyphens, starting and ending with a letter or number, and not a standard event name. Keep it identical on any server-side Conversions API call for deduplication."
      },
      {
        "type": "TEXT",
        "name": "eventId",
        "displayName": "Event ID",
        "simpleValueType": true,
        "help": "Optional deduplication ID. Leave blank unless another system will send the same conversion server-side."
      },
      {
        "type": "TEXT",
        "name": "optOut",
        "displayName": "Per-event opt-out flag",
        "simpleValueType": true,
        "valueHint": "true, false, or GTM variable",
        "help": "Optional. Enter true or false, or choose a GTM variable that resolves to boolean true, boolean false, or empty. This reports opt_out metadata downstream; it does not block transport."
      },
      {
        "type": "TEXT",
        "name": "amount",
        "displayName": "Amount",
        "simpleValueType": true,
        "help": "Optional integer amount in minor currency units, for example 4200 for $42.00. If set, Currency is required."
      },
      {
        "type": "TEXT",
        "name": "currency",
        "displayName": "Currency",
        "simpleValueType": true,
        "help": "Optional 3-letter ISO 4217 currency code such as USD. Required when Amount is set."
      },
      {
        "type": "TEXT",
        "name": "planId",
        "displayName": "Plan ID",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "eventName",
            "paramValue": "custom",
            "type": "EQUALS"
          },
          {
            "paramName": "eventName",
            "paramValue": "subscription_created",
            "type": "EQUALS"
          },
          {
            "paramName": "eventName",
            "paramValue": "trial_started",
            "type": "EQUALS"
          }
        ],
        "help": "Optional plan or subscription identifier. Used for trial and subscription events."
      },
      {
        "type": "GROUP",
        "name": "contentsSettings",
        "displayName": "Contents",
        "groupStyle": "ZIPPY_CLOSED",
        "enablingConditions": [
          {
            "paramName": "eventName",
            "paramValue": "checkout_started",
            "type": "EQUALS"
          },
          {
            "paramName": "eventName",
            "paramValue": "contents_viewed",
            "type": "EQUALS"
          },
          {
            "paramName": "eventName",
            "paramValue": "custom",
            "type": "EQUALS"
          },
          {
            "paramName": "eventName",
            "paramValue": "items_added",
            "type": "EQUALS"
          },
          {
            "paramName": "eventName",
            "paramValue": "order_created",
            "type": "EQUALS"
          },
          {
            "paramName": "eventName",
            "paramValue": "page_viewed",
            "type": "EQUALS"
          },
          {
            "paramName": "eventName",
            "paramValue": "subscription_created",
            "type": "EQUALS"
          },
          {
            "paramName": "eventName",
            "paramValue": "trial_started",
            "type": "EQUALS"
          }
        ],
        "subParams": [
          {
            "type": "SELECT",
            "name": "contentsSource",
            "displayName": "Contents source",
            "simpleValueType": true,
            "defaultValue": "manual",
            "selectItems": [
              {
                "value": "manual",
                "displayValue": "Manual table"
              },
              {
                "value": "variable",
                "displayValue": "GTM variable"
              }
            ],
            "help": "Choose a manual table or a GTM variable that resolves to an array of documented Content objects."
          },
          {
            "type": "SIMPLE_TABLE",
            "name": "contents",
            "displayName": "Content items",
            "enablingConditions": [
              {
                "paramName": "contentsSource",
                "paramValue": "manual",
                "type": "EQUALS"
              }
            ],
            "simpleTableColumns": [
              {
                "defaultValue": "",
                "displayName": "Content type",
                "name": "contentType",
                "type": "TEXT"
              },
              {
                "defaultValue": "",
                "displayName": "ID",
                "name": "id",
                "type": "TEXT"
              },
              {
                "defaultValue": "",
                "displayName": "Name",
                "name": "name",
                "type": "TEXT"
              },
              {
                "defaultValue": "",
                "displayName": "Quantity",
                "name": "quantity",
                "type": "TEXT"
              },
              {
                "defaultValue": "",
                "displayName": "Amount",
                "name": "amount",
                "type": "TEXT"
              },
              {
                "defaultValue": "",
                "displayName": "Currency",
                "name": "currency",
                "type": "TEXT"
              }
            ],
            "newRowButtonText": "Add content item",
            "help": "Optional. Add content items associated with the event. Monetary amounts use minor currency units."
          },
          {
            "type": "TEXT",
            "name": "dynamicContents",
            "displayName": "Contents variable",
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "contentsSource",
                "paramValue": "variable",
                "type": "EQUALS"
              }
            ],
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "help": "Select a GTM variable that resolves to an array of objects. Supported item keys are id, name, content_type, quantity, amount, and currency; other keys are ignored. An empty or undefined variable sends the event without contents."
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "userSettings",
    "displayName": "User matching",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "hashUserData",
        "checkboxText": "Normalize and SHA-256 hash raw identifiers in the browser",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "Recommended. A value that is already a 64-character hexadecimal digest is passed through in lowercase. Any other value is normalized following the OpenAI rules and hashed with the browser Web Crypto API before it is handed to the SDK, so no raw identifier enters the page-global oaiq queue. Clear this box to skip any identifier that is not already hashed; the event is still sent. A field that cannot be normalized is skipped and logged in GTM Preview, never blocking the conversion."
      },
      {
        "type": "TEXT",
        "name": "emailSha256",
        "displayName": "Email",
        "simpleValueType": true,
        "help": "Optional. A SHA-256 digest, or a raw email address when in-browser hashing is on. Normalization: trim whitespace and lowercase."
      },
      {
        "type": "TEXT",
        "name": "phoneNumberSha256",
        "displayName": "Phone number",
        "simpleValueType": true,
        "help": "Optional. A SHA-256 digest, or a raw phone number when in-browser hashing is on. Normalization: keep the country code and digits only, drop a leading plus and leading zeroes, leaving 8 to 15 digits."
      },
      {
        "type": "TEXT",
        "name": "externalIdSha256",
        "displayName": "External ID",
        "simpleValueType": true,
        "help": "Optional. A SHA-256 digest, or a raw pseudonymous customer ID when in-browser hashing is on. Normalization: trim whitespace only, case and all other characters are preserved."
      },
      {
        "type": "TEXT",
        "name": "firstNameSha256",
        "displayName": "First name",
        "simpleValueType": true,
        "help": "Optional. A SHA-256 digest, or a raw first name when in-browser hashing is on. Normalization: lowercase, remove whitespace and ASCII punctuation, keep accents."
      },
      {
        "type": "TEXT",
        "name": "lastNameSha256",
        "displayName": "Last name",
        "simpleValueType": true,
        "help": "Optional. A SHA-256 digest, or a raw last name when in-browser hashing is on. Normalization: lowercase, remove whitespace and ASCII punctuation, keep accents."
      },
      {
        "type": "TEXT",
        "name": "country",
        "displayName": "Country",
        "simpleValueType": true,
        "help": "Optional ISO 3166-1 country code such as US."
      },
      {
        "type": "TEXT",
        "name": "city",
        "displayName": "City",
        "simpleValueType": true,
        "help": "Optional city name, up to 128 characters."
      },
      {
        "type": "TEXT",
        "name": "region",
        "displayName": "Region",
        "simpleValueType": true,
        "help": "Optional state, province, or region, up to 128 characters."
      },
      {
        "type": "TEXT",
        "name": "postalCode",
        "displayName": "Postal code",
        "simpleValueType": true,
        "help": "Optional postal or ZIP code, up to 32 characters."
      }
    ]
  }
]

___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const addConsentListener = require('addConsentListener');
const callInWindow = require('callInWindow');
const copyFromWindow = require('copyFromWindow');
const createArgumentsQueue = require('createArgumentsQueue');
const getContainerVersion = require('getContainerVersion');
const getType = require('getType');
const injectScript = require('injectScript');
const isConsentGranted = require('isConsentGranted');
const logToConsole = require('logToConsole');
const makeInteger = require('makeInteger');
const makeString = require('makeString');
const sha256 = require('sha256');
const templateStorage = require('templateStorage');

const SDK_URL = 'https://bzrcdn.openai.com/sdk/oaiq.min.js';
const CACHE_TOKEN = 'openai_ads_pixel_sdk';
const CONSENT_SYNCED_KEY = 'openai_ads_consent_synced';
const INITIALIZED_PIXELS_KEY = 'openai_ads_initialized_pixel_ids';
const USER_LISTENER_KEY_PREFIX = 'openai_ads_user_listener_';
const LOG_PREFIX = '[OpenAI Ads Measurement Pixel] ';
const AD_STORAGE = 'ad_storage';
const AD_USER_DATA = 'ad_user_data';

const containerVersion = getContainerVersion() || {};
const debugEnabled =
  data.enableDebug === true ||
  containerVersion.debugMode === true ||
  containerVersion.previewMode === true;

const EVENT_DATA_TYPES = {
  appointment_scheduled: 'customer_action',
  checkout_started: 'contents',
  contents_viewed: 'contents',
  custom: 'custom',
  items_added: 'contents',
  lead_created: 'customer_action',
  order_created: 'contents',
  page_viewed: 'contents',
  registration_completed: 'customer_action',
  subscription_created: 'plan_enrollment',
  trial_started: 'plan_enrollment'
};

// Template policy: every standard event name documented by OpenAI Ads, including
// the two Conversions API only events, is reserved and cannot be reused as a
// custom event name. The SDK itself only reserves the eleven web event names.
const RESERVED_EVENT_NAMES = {
  app_installed: true,
  app_opened: true,
  appointment_scheduled: true,
  checkout_started: true,
  contents_viewed: true,
  custom: true,
  items_added: true,
  lead_created: true,
  order_created: true,
  page_viewed: true,
  registration_completed: true,
  subscription_created: true,
  trial_started: true
};

const LOWERCASE_LETTERS = 'abcdefghijklmnopqrstuvwxyz';
const UPPERCASE_LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const LETTERS = LOWERCASE_LETTERS + UPPERCASE_LETTERS;
const DIGITS = '0123456789';
const ALPHANUMERIC = LETTERS + DIGITS;
const LOWER_ALPHANUMERIC = LOWERCASE_LETTERS + DIGITS;
const HEX_CHARACTERS = '0123456789abcdef';
// ASCII whitespace plus the Unicode spaces that JavaScript's \s matches, so a
// name pasted with a non-breaking space hashes like a server-side normalizer.
const WHITESPACE_CHARACTERS = ' \t\n\r\f\u000B\u00A0\u1680\u2000\u2001\u2002\u2003' +
  '\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u2028\u2029\u202F\u205F\u3000\uFEFF';
const ASCII_PUNCTUATION = '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~';

const log = message => {
  if (debugEnabled) {
    logToConsole(LOG_PREFIX + message);
  }
};

const hasValue = value => value !== undefined && value !== null && value !== '';

// True when every character of text belongs to alphabet.
const onlyChars = (text, alphabet) => {
  for (let i = 0; i < text.length; i += 1) {
    if (alphabet.indexOf(text.charAt(i)) < 0) {
      return false;
    }
  }
  return true;
};

// Returns text with every character outside alphabet removed.
const keepChars = (text, alphabet) => {
  let kept = '';
  for (let i = 0; i < text.length; i += 1) {
    const character = text.charAt(i);
    if (alphabet.indexOf(character) >= 0) {
      kept += character;
    }
  }
  return kept;
};

// Returns text with every character of alphabet removed.
const dropChars = (text, alphabet) => {
  let kept = '';
  for (let i = 0; i < text.length; i += 1) {
    const character = text.charAt(i);
    if (alphabet.indexOf(character) < 0) {
      kept += character;
    }
  }
  return kept;
};

const isOptOutLike = value =>
  !hasValue(value) || value === 'omit' || value === true || value === false ||
  value === 'true' || value === 'false';

const parseOptOut = value => {
  if (value === true || value === 'true') {
    return true;
  }
  if (value === false || value === 'false') {
    return false;
  }
  return null;
};

const isContentsCapableType = dataType =>
  dataType === 'contents' || dataType === 'custom' || dataType === 'plan_enrollment';
const isPlanCapableType = dataType => dataType === 'custom' || dataType === 'plan_enrollment';

// The SDK accepts /^[A-Za-z]{3}$/ for currency codes.
const isCurrencyLike = value => {
  if (!hasValue(value)) {
    return true;
  }
  const text = makeString(value);
  return text.length === 3 && onlyChars(text, LETTERS);
};

const isIntegerLike = value => {
  if (!hasValue(value)) {
    return true;
  }
  return onlyChars(makeString(value), DIGITS);
};

// The SDK accepts /^[0-9a-f]{64}$/i and lowercases the digest.
const toSha256Hex = value => {
  if (!hasValue(value)) {
    return null;
  }
  const text = makeString(value);
  if (text.length !== 64) {
    return null;
  }
  const lowered = text.toLowerCase();
  return onlyChars(lowered, HEX_CHARACTERS) ? lowered : null;
};

// Ads Manager only registers lowercase custom event names, so the template
// lowercases the configured value before validating and sending it. The
// documented rules are then: 1-64 characters, letters, numbers, underscores or
// hyphens, alphanumeric first and last character, not a standard event name.
const normalizeCustomEventName = value => makeString(value).trim().toLowerCase();

const isCustomEventNameLike = text =>
  text.length >= 1 &&
  text.length <= 64 &&
  RESERVED_EVENT_NAMES[text] !== true &&
  onlyChars(text, LOWER_ALPHANUMERIC + '_-') &&
  LOWER_ALPHANUMERIC.indexOf(text.charAt(0)) >= 0 &&
  LOWER_ALPHANUMERIC.indexOf(text.charAt(text.length - 1)) >= 0;

const isCountryLike = text => text.length === 2 && onlyChars(text, LETTERS);

const isPostalCodeLike = text => text.length <= 32 && onlyChars(text, ALPHANUMERIC + ' -');

// Normalization rules from the "Normalize identifiers before hashing" section of
// https://developers.openai.com/ads/measurement-pixel
const normalizeEmail = value => makeString(value).trim().toLowerCase();

const normalizeExternalId = value => makeString(value).trim();

const normalizeName = value =>
  dropChars(makeString(value).toLowerCase(), WHITESPACE_CHARACTERS + ASCII_PUNCTUATION);

const normalizePhone = value => {
  const digits = keepChars(makeString(value), DIGITS);
  let start = 0;
  while (start < digits.length && digits.charAt(start) === '0') {
    start += 1;
  }
  return digits.substring(start);
};

const HASHED_USER_FIELDS = [
  {
    key: 'email_sha256',
    label: 'Email',
    raw: data.emailSha256,
    normalize: normalizeEmail,
    minimumLength: 3,
    maximumLength: 1024
  },
  {
    key: 'phone_number_sha256',
    label: 'Phone number',
    raw: data.phoneNumberSha256,
    normalize: normalizePhone,
    minimumLength: 8,
    maximumLength: 15
  },
  {
    key: 'external_id_sha256',
    label: 'External ID',
    raw: data.externalIdSha256,
    normalize: normalizeExternalId,
    minimumLength: 1,
    maximumLength: 1024
  },
  {
    key: 'first_name_sha256',
    label: 'First name',
    raw: data.firstNameSha256,
    normalize: normalizeName,
    minimumLength: 1,
    maximumLength: 1024
  },
  {
    key: 'last_name_sha256',
    label: 'Last name',
    raw: data.lastNameSha256,
    normalize: normalizeName,
    minimumLength: 1,
    maximumLength: 1024
  }
];

// Tags created with the upstream template stored the postal code as zipCode.
const configuredPostalCode = hasValue(data.postalCode) ? data.postalCode : data.zipCode;

const LOCATION_USER_FIELDS = [
  {key: 'country', label: 'Country', raw: data.country, maximumLength: 2},
  {key: 'city', label: 'City', raw: data.city, maximumLength: 128},
  {key: 'region', label: 'Region', raw: data.region, maximumLength: 128},
  {key: 'postal_code', label: 'Postal code', raw: configuredPostalCode, maximumLength: 32}
];

const hashRawUserData = data.hashUserData !== false;

const hasConfiguredUserData = () => {
  for (let i = 0; i < HASHED_USER_FIELDS.length; i += 1) {
    if (hasValue(HASHED_USER_FIELDS[i].raw)) {
      return true;
    }
  }
  for (let i = 0; i < LOCATION_USER_FIELDS.length; i += 1) {
    if (hasValue(LOCATION_USER_FIELDS[i].raw)) {
      return true;
    }
  }
  return false;
};

const addString = (target, key, value) => {
  if (hasValue(value)) {
    target[key] = makeString(value);
  }
};

const addInteger = (target, key, value) => {
  if (hasValue(value)) {
    target[key] = makeInteger(value);
  }
};

const hasKeys = object => {
  for (const key in object) {
    return true;
  }
  return false;
};

const countKeys = object => {
  let count = 0;
  for (const key in object) {
    count += 1;
  }
  return count;
};

const hasAnyValue = object => {
  if (!object) {
    return false;
  }
  for (const key in object) {
    if (hasValue(object[key])) {
      return true;
    }
  }
  return false;
};

let finished = false;

const finish = success => {
  if (finished) {
    return;
  }
  finished = true;
  if (success) {
    data.gtmOnSuccess();
  } else {
    data.gtmOnFailure();
  }
};

const fail = message => {
  log(message);
  finish(false);
};

// Forwards a command to window.oaiq with the exact number of arguments given,
// through callInWindow when the global exists and through a new arguments queue
// otherwise. The sandbox has no apply or rest arguments, hence the ladder.
const callOaiq = (command, arg1, arg2, arg3, arg4) => {
  if (copyFromWindow('oaiq')) {
    if (arg4 !== undefined) {
      callInWindow('oaiq', command, arg1, arg2, arg3, arg4);
    } else if (arg3 !== undefined) {
      callInWindow('oaiq', command, arg1, arg2, arg3);
    } else if (arg2 !== undefined) {
      callInWindow('oaiq', command, arg1, arg2);
    } else if (arg1 !== undefined) {
      callInWindow('oaiq', command, arg1);
    } else {
      callInWindow('oaiq', command);
    }
    return;
  }

  const oaiq = createArgumentsQueue('oaiq', 'oaiq.queue');
  if (arg4 !== undefined) {
    oaiq(command, arg1, arg2, arg3, arg4);
  } else if (arg3 !== undefined) {
    oaiq(command, arg1, arg2, arg3);
  } else if (arg2 !== undefined) {
    oaiq(command, arg1, arg2);
  } else if (arg1 !== undefined) {
    oaiq(command, arg1);
  } else {
    oaiq(command);
  }
};

// Builds the user object. Matching data is optional, so a field that cannot be
// sent is dropped with a debug log instead of failing the conversion. Returns
// digests that are ready to send and raw values that still need SHA-256.
const planUserData = () => {
  const user = {};
  const pending = [];

  for (let i = 0; i < HASHED_USER_FIELDS.length; i += 1) {
    const field = HASHED_USER_FIELDS[i];
    if (!hasValue(field.raw)) {
      continue;
    }
    const digest = toSha256Hex(field.raw);
    if (digest) {
      user[field.key] = digest;
      continue;
    }
    if (!hashRawUserData) {
      log(field.label + ' is not a SHA-256 digest and in-browser hashing is off, skipping it.');
      continue;
    }
    const normalized = field.normalize(field.raw);
    if (normalized.length < field.minimumLength || normalized.length > field.maximumLength) {
      log(field.label + ' could not be normalized into a value the Pixel accepts, skipping it.');
      continue;
    }
    pending.push({key: field.key, value: normalized});
  }

  for (let i = 0; i < LOCATION_USER_FIELDS.length; i += 1) {
    const field = LOCATION_USER_FIELDS[i];
    if (!hasValue(field.raw)) {
      continue;
    }
    const text = makeString(field.raw).trim();
    let accepted = text.length > 0 && text.length <= field.maximumLength;
    if (field.key === 'country') {
      accepted = isCountryLike(text);
    } else if (field.key === 'postal_code') {
      accepted = accepted && isPostalCodeLike(text);
    }
    if (!accepted) {
      log(field.label + ' is not a value the Pixel accepts, skipping it.');
      continue;
    }
    user[field.key] = text;
  }

  return {user: user, pending: pending};
};

const resolveUserData = (plan, callback) => {
  const pending = plan.pending;

  const hashNext = index => {
    if (index >= pending.length) {
      callback(plan.user);
      return;
    }
    const item = pending[index];
    sha256(
      item.value,
      digest => {
        plan.user[item.key] = digest;
        hashNext(index + 1);
      },
      () => {
        log('SHA-256 is unavailable in this browser, skipping ' + item.key + '.');
        hashNext(index + 1);
      },
      {outputEncoding: 'hex'}
    );
  };

  hashNext(0);
};

const buildUserObject = callback => {
  const plan = planUserData();
  if (plan.pending.length === 0) {
    callback(plan.user);
    return;
  }
  resolveUserData(plan, callback);
};

const getContentsRows = () => {
  if (data.contentsSource === 'variable') {
    return hasValue(data.dynamicContents) ? data.dynamicContents : [];
  }
  return data.contents || [];
};

const buildContents = () => {
  const rows = getContentsRows();
  const contents = [];
  for (let i = 0; i < rows.length; i += 1) {
    const row = rows[i];
    if (!hasAnyValue(row)) {
      continue;
    }
    const content = {};
    addString(
      content,
      'content_type',
      hasValue(row.content_type) ? row.content_type : row.contentType
    );
    addString(content, 'id', row.id);
    addString(content, 'name', row.name);
    addInteger(content, 'quantity', row.quantity);
    addInteger(content, 'amount', row.amount);
    addString(content, 'currency', row.currency);
    if (hasKeys(content)) {
      contents.push(content);
    }
  }
  return contents;
};

const buildEventProps = eventName => {
  const dataType = EVENT_DATA_TYPES[eventName] || 'custom';
  const eventProps = {
    type: dataType
  };

  addInteger(eventProps, 'amount', data.amount);
  addString(eventProps, 'currency', data.currency);
  if (isPlanCapableType(dataType)) {
    addString(eventProps, 'plan_id', data.planId);
  }

  if (isContentsCapableType(dataType)) {
    const contents = buildContents();
    if (contents.length > 0) {
      eventProps.contents = contents;
    }
  }

  return eventProps;
};

const buildEventOptions = (eventName, customEventName) => {
  const eventOptions = {};
  addString(eventOptions, 'event_id', data.eventId);

  if (eventName === 'custom') {
    eventOptions.custom_event_name = customEventName;
  }

  const optOut = parseOptOut(data.optOut);
  if (optOut !== null) {
    eventOptions.opt_out = optOut;
  }

  return eventOptions;
};

const validateEventConfig = (eventName, customEventName) => {
  const dataType = EVENT_DATA_TYPES[eventName];
  if (!dataType) {
    return 'Choose a documented OpenAI Ads event name.';
  }

  if (eventName === 'custom' && !isCustomEventNameLike(customEventName)) {
    return 'Custom event name must be 1-64 characters, use letters, numbers, underscores, or hyphens, start and end with a letter or number, and not match a standard event.';
  }

  if (!isOptOutLike(data.optOut)) {
    return 'Per-event opt-out flag must resolve to true, false, or be empty.';
  }

  if (!isIntegerLike(data.amount)) {
    return 'Amount must be an integer in minor currency units, for example 4200 for $42.00.';
  }

  if (hasValue(data.amount) && !hasValue(data.currency)) {
    return 'Currency is required when Amount is set.';
  }

  if (!isCurrencyLike(data.currency)) {
    return 'Currency must be a 3-letter ISO 4217 code, for example USD.';
  }

  if (!isContentsCapableType(dataType)) {
    return null;
  }

  const rows = getContentsRows();
  if (getType(rows) !== 'array') {
    return 'Contents must resolve to an array, or be empty.';
  }
  for (let i = 0; i < rows.length; i += 1) {
    const row = rows[i];
    if (row === undefined || row === null) {
      continue;
    }
    if (getType(row) !== 'object') {
      return 'Each Contents item must be an object.';
    }
    if (!hasAnyValue(row)) {
      continue;
    }
    if (!isIntegerLike(row.quantity)) {
      return 'Content Quantity must be an integer.';
    }
    if (!isIntegerLike(row.amount)) {
      return 'Content Amount must be an integer in minor currency units.';
    }
    if (hasValue(row.amount) && !hasValue(row.currency) && !hasValue(data.currency)) {
      return 'Content Currency or top-level Currency is required when a content Amount is set.';
    }
    if (!isCurrencyLike(row.currency)) {
      return 'Content Currency must be a 3-letter ISO 4217 code, for example USD.';
    }
  }

  return null;
};

if (!hasValue(data.pixelId)) {
  fail('Pixel ID is required. The configured value resolved to an empty value.');
  return;
}

const pixelId = makeString(data.pixelId);
const sendEvent = data.sendEvent === true;

let eventName;
let customEventName;
if (sendEvent) {
  eventName = data.eventName || 'page_viewed';
  if (eventName === 'custom') {
    customEventName = hasValue(data.customEventName) ?
      normalizeCustomEventName(data.customEventName) : '';
    if (customEventName !== '' && customEventName !== makeString(data.customEventName)) {
      log('Custom event name was normalized to "' + customEventName + '".');
    }
  }
  const eventValidationError = validateEventConfig(eventName, customEventName);
  if (eventValidationError) {
    fail(eventValidationError);
    return;
  }
}

const respectGtmConsent = data.respectGtmConsent !== false;
const deferUntilConsent = respectGtmConsent && (data.consentMode || 'defer') === 'defer';
const pixelTargeting = data.pixelTargeting || 'auto';

// Sends the current ad_storage state to the SDK once per page and keeps it in
// sync afterwards through a single consent listener.
const syncConsentSignal = () => {
  if (!respectGtmConsent || templateStorage.getItem(CONSENT_SYNCED_KEY)) {
    return;
  }
  templateStorage.setItem(CONSENT_SYNCED_KEY, true);
  callOaiq('consent', isConsentGranted(AD_STORAGE));
  addConsentListener(AD_STORAGE, (consentType, granted) => {
    callOaiq('consent', granted);
  });
};

const buildInitConfig = user => {
  const initConfig = {
    pixelId: pixelId
  };
  if (debugEnabled) {
    initConfig.debug = true;
  }
  if (hasKeys(user)) {
    initConfig.user = user;
  }
  return initConfig;
};

const initializePixel = user => {
  const initializedPixelIds = templateStorage.getItem(INITIALIZED_PIXELS_KEY) || {};
  if (!initializedPixelIds[pixelId]) {
    callOaiq('init', buildInitConfig(user));
    initializedPixelIds[pixelId] = true;
    templateStorage.setItem(INITIALIZED_PIXELS_KEY, initializedPixelIds);
  } else if (hasKeys(user) || debugEnabled) {
    // A repeated init on a known Pixel ID only updates user data and the debug
    // flag. The Pixel ID is always included so the update cannot land on a pixel
    // initialized outside this template.
    callOaiq('init', buildInitConfig(user));
  }
  return countKeys(initializedPixelIds);
};

// When ad_user_data is denied at fire time, one tag per Pixel ID waits for the
// grant and then sends the configured user data with a targeted init.
const sendUserDataOnConsent = () => {
  const listenerKey = USER_LISTENER_KEY_PREFIX + pixelId;
  if (!hasConfiguredUserData() || templateStorage.getItem(listenerKey)) {
    return;
  }
  templateStorage.setItem(listenerKey, true);
  let sent = false;
  addConsentListener(AD_USER_DATA, (consentType, granted) => {
    if (!granted || sent) {
      return;
    }
    sent = true;
    buildUserObject(user => {
      if (hasKeys(user)) {
        callOaiq('init', buildInitConfig(user));
      }
    });
  });
};

const dispatch = user => {
  syncConsentSignal();
  const initializedPixelCount = initializePixel(user);

  if (sendEvent) {
    const eventProps = buildEventProps(eventName);
    const eventOptions = buildEventOptions(eventName, customEventName);
    const targetSinglePixel = pixelTargeting === 'single' ||
      (pixelTargeting === 'auto' && initializedPixelCount > 1);
    if (targetSinglePixel) {
      callOaiq('measureSingle', pixelId, eventName, eventProps, eventOptions);
    } else {
      callOaiq('measure', eventName, eventProps, eventOptions);
    }
  }

  injectScript(SDK_URL, () => finish(true), () => fail('Failed to load ' + SDK_URL), CACHE_TOKEN);
};

const execute = () => {
  if (respectGtmConsent && !isConsentGranted(AD_USER_DATA)) {
    dispatch({});
    sendUserDataOnConsent();
    return;
  }
  buildUserObject(dispatch);
};

// Default mode: while ad_storage is denied the SDK stays off the page, so OpenAI
// writes no cookie and receives no request. The event is replayed once consent
// is granted, which the SDK does not do on its own. GTM allows a single
// completion callback per tag, so the tag reports success when it starts waiting.
if (deferUntilConsent && !isConsentGranted(AD_STORAGE)) {
  log('Consent for ' + AD_STORAGE + ' is denied, deferring the SDK load and the event.');
  let replayed = false;
  addConsentListener(AD_STORAGE, (consentType, granted) => {
    if (granted && !replayed) {
      replayed = true;
      execute();
    }
  });
  finish(true);
} else {
  execute();
}

___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_container_data",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_user_data"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "oaiq"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "oaiq.queue"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://bzrcdn.openai.com/sdk/oaiq.min.js"
              }
            ]
          }
        }
      ]
    },
    "isRequired": true
  }
]

___TESTS___

scenarios:
- name: queues conversion
  code: |-
    let injectedUrl;
    let injectedCacheToken;
    mock('injectScript', function(url, onSuccess, onFailure, cacheToken) {
      injectedUrl = url;
      injectedCacheToken = cacheToken;
      onSuccess();
    });

    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      enableDebug: false,
      eventName: 'order_created',
      amount: '4200',
      currency: 'USD',
      optOut: true,
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(3);
    assertThat(queued[0][0]).isEqualTo('consent');
    assertThat(queued[0][1]).isEqualTo(true);
    assertThat(queued[1][0]).isEqualTo('init');
    assertThat(queued[1][1]).isEqualTo({pixelId: 'px_123'});
    assertThat(queued[2][0]).isEqualTo('measure');
    assertThat(queued[2][1]).isEqualTo('order_created');
    assertThat(queued[2][2]).isEqualTo({type: 'contents', amount: 4200, currency: 'USD'});
    assertThat(queued[2][3]).isEqualTo({opt_out: true});
    assertThat(injectedUrl).isEqualTo('https://bzrcdn.openai.com/sdk/oaiq.min.js');
    assertThat(injectedCacheToken).isEqualTo('openai_ads_pixel_sdk');
    assertApi('gtmOnSuccess').wasCalled();
- name: blocks invalid opt_out variable values
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'lead_created',
      optOut: 'yes',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(0);
    assertApi('injectScript').wasNotCalled();
    assertApi('gtmOnFailure').wasCalled();
- name: fails when the pixel id resolves to an empty value
  code: |-
    runCode({
      pixelId: '',
      sendEvent: true,
      eventName: 'page_viewed',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(0);
    assertApi('injectScript').wasNotCalled();
    assertApi('gtmOnFailure').wasCalled();
- name: enables sdk debug in GTM preview mode
  code: |-
    mock('getContainerVersion', function() {
      return {debugMode: false, previewMode: true};
    });

    runCode({
      pixelId: 'px_123',
      sendEvent: false,
      enableDebug: false,
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(2);
    assertThat(queued[0][0]).isEqualTo('consent');
    assertThat(queued[1][0]).isEqualTo('init');
    assertThat(queued[1][1]).isEqualTo({pixelId: 'px_123', debug: true});
- name: re-sends debug on a repeated init when diagnostics are enabled
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: false,
      enableDebug: false,
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'lead_created',
      enableDebug: true,
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(4);
    assertThat(queued[1][1]).isEqualTo({pixelId: 'px_123'});
    assertThat(queued[2][0]).isEqualTo('init');
    assertThat(queued[2][1]).isEqualTo({pixelId: 'px_123', debug: true});
    assertThat(queued[3][0]).isEqualTo('measure');
- name: queues content rows without content_type
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'order_created',
      amount: '4200',
      currency: 'USD',
      contents: [{id: 'sku_123', name: 'Test Product', quantity: '2'}],
      optOut: 'omit',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(3);
    assertThat(queued[2][0]).isEqualTo('measure');
    assertThat(queued[2][1]).isEqualTo('order_created');
    assertThat(queued[2][2]).isEqualTo({
      type: 'contents',
      amount: 4200,
      currency: 'USD',
      contents: [{id: 'sku_123', name: 'Test Product', quantity: 2}]
    });
    assertThat(queued[2][3]).isEqualTo({});
- name: queues page_viewed data
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'page_viewed',
      amount: '100',
      currency: 'USD',
      contents: [{contentType: 'page', id: 'pricing', name: 'Pricing page'}],
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(3);
    assertThat(queued[2][1]).isEqualTo('page_viewed');
    assertThat(queued[2][2]).isEqualTo({
      type: 'contents',
      amount: 100,
      currency: 'USD',
      contents: [{content_type: 'page', id: 'pricing', name: 'Pricing page'}]
    });
    assertThat(queued[2][3]).isEqualTo({});
- name: queues dynamic contents using documented keys
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'items_added',
      contentsSource: 'variable',
      dynamicContents: [{
        id: 'sku_456',
        name: 'Dynamic product',
        content_type: 'product',
        quantity: 2,
        amount: 1500,
        currency: 'EUR'
      }],
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued[2][0]).isEqualTo('measure');
    assertThat(queued[2][2]).isEqualTo({
      type: 'contents',
      contents: [{
        id: 'sku_456',
        name: 'Dynamic product',
        content_type: 'product',
        quantity: 2,
        amount: 1500,
        currency: 'EUR'
      }]
    });
- name: sends the event without contents when the contents variable is empty
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'order_created',
      amount: '2599',
      currency: 'EUR',
      contentsSource: 'variable',
      dynamicContents: undefined,
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(3);
    assertThat(queued[2][1]).isEqualTo('order_created');
    assertThat(queued[2][2]).isEqualTo({type: 'contents', amount: 2599, currency: 'EUR'});
    assertApi('gtmOnSuccess').wasCalled();
    assertApi('gtmOnFailure').wasNotCalled();

    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'page_viewed',
      contentsSource: 'variable',
      dynamicContents: 'not an array',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(3);
    assertApi('gtmOnFailure').wasCalled();
- name: defers the sdk until ad_storage consent is granted
  code: |-
    consentState.ad_storage = false;

    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'lead_created',
      respectGtmConsent: true,
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(0);
    assertApi('injectScript').wasNotCalled();
    assertApi('gtmOnSuccess').wasCalled();

    grant('ad_storage');

    assertThat(queued).hasLength(3);
    assertThat(queued[0][0]).isEqualTo('consent');
    assertThat(queued[0][1]).isEqualTo(true);
    assertThat(queued[1][0]).isEqualTo('init');
    assertThat(queued[2][0]).isEqualTo('measure');
    assertThat(queued[2][1]).isEqualTo('lead_created');
    assertApi('injectScript').wasCalled();
- name: signal mode loads the sdk and syncs denied consent
  code: |-
    consentState.ad_storage = false;
    consentState.ad_user_data = false;

    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'lead_created',
      respectGtmConsent: true,
      consentMode: 'signal',
      emailSha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(3);
    assertThat(queued[0][0]).isEqualTo('consent');
    assertThat(queued[0][1]).isEqualTo(false);
    assertThat(queued[1][0]).isEqualTo('init');
    assertThat(queued[1][1]).isEqualTo({pixelId: 'px_123'});
    assertThat(queued[2][0]).isEqualTo('measure');
    assertApi('injectScript').wasCalled();

    grant('ad_storage');

    assertThat(queued).hasLength(4);
    assertThat(queued[3][0]).isEqualTo('consent');
    assertThat(queued[3][1]).isEqualTo(true);
- name: sends user data once when ad_user_data is granted later
  code: |-
    consentState.ad_user_data = false;

    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'page_viewed',
      emailSha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'lead_created',
      emailSha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(4);
    assertThat(queued[1][1]).isEqualTo({pixelId: 'px_123'});
    assertThat(consentListeners.ad_user_data).hasLength(1);

    grant('ad_user_data');
    grant('ad_user_data');

    assertThat(queued).hasLength(5);
    assertThat(queued[4][0]).isEqualTo('init');
    assertThat(queued[4][1]).isEqualTo({
      pixelId: 'px_123',
      user: {email_sha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'}
    });
- name: sends the consent command once per page
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'page_viewed',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'lead_created',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    let consentCommands = 0;
    for (let i = 0; i < queued.length; i += 1) {
      if (queued[i][0] === 'consent') {
        consentCommands += 1;
      }
    }
    assertThat(consentCommands).isEqualTo(1);
    assertThat(consentListeners.ad_storage).hasLength(1);
    assertThat(queued).hasLength(4);
- name: sends current documented user fields
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: false,
      emailSha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      phoneNumberSha256: 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
      externalIdSha256: 'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc',
      firstNameSha256: 'dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd',
      lastNameSha256: 'eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee',
      country: 'IT',
      city: 'Rome',
      region: 'Lazio',
      postalCode: '00100',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued[1][1]).isEqualTo({
      pixelId: 'px_123',
      user: {
        email_sha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
        phone_number_sha256: 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
        external_id_sha256: 'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc',
        first_name_sha256: 'dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd',
        last_name_sha256: 'eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee',
        country: 'IT',
        city: 'Rome',
        region: 'Lazio',
        postal_code: '00100'
      }
    });
- name: accepts the legacy zipCode parameter
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: false,
      zipCode: '00100',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued[1][1]).isEqualTo({pixelId: 'px_123', user: {postal_code: '00100'}});
- name: normalizes and hashes raw identifiers before init
  code: |-
    let hashedInputs = [];
    mock('sha256', function(input, onSuccess, onFailure, options) {
      assertThat(options).isEqualTo({outputEncoding: 'hex'});
      hashedInputs.push(input);
      onSuccess('hash:' + input);
    });

    runCode({
      pixelId: 'px_123',
      sendEvent: false,
      hashUserData: true,
      emailSha256: '  Mary.Jane@Example.COM ',
      phoneNumberSha256: '+1 (415) 555-2671',
      externalIdSha256: '  Cust-42  ',
      firstNameSha256: 'Mary Jane',
      lastNameSha256: "O'Connor",
      country: 'US',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(hashedInputs).isEqualTo([
      'mary.jane@example.com',
      '14155552671',
      'Cust-42',
      'maryjane',
      'oconnor'
    ]);
    assertThat(queued[1][1]).isEqualTo({
      pixelId: 'px_123',
      user: {
        country: 'US',
        email_sha256: 'hash:mary.jane@example.com',
        phone_number_sha256: 'hash:14155552671',
        external_id_sha256: 'hash:Cust-42',
        first_name_sha256: 'hash:maryjane',
        last_name_sha256: 'hash:oconnor'
      }
    });
- name: skips raw identifiers when in-browser hashing is off
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'lead_created',
      hashUserData: false,
      emailSha256: 'mary.jane@example.com',
      externalIdSha256: 'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertApi('sha256').wasNotCalled();
    assertApi('gtmOnFailure').wasNotCalled();
    assertThat(queued).hasLength(3);
    assertThat(queued[1][1]).isEqualTo({
      pixelId: 'px_123',
      user: {external_id_sha256: 'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc'}
    });
    assertThat(queued[2][0]).isEqualTo('measure');
- name: skips invalid user fields without dropping the conversion
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'registration_completed',
      phoneNumberSha256: '555',
      country: 'Italy',
      city: 'Rome',
      postalCode: '00100!',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertApi('sha256').wasNotCalled();
    assertApi('gtmOnFailure').wasNotCalled();
    assertThat(queued).hasLength(3);
    assertThat(queued[1][1]).isEqualTo({pixelId: 'px_123', user: {city: 'Rome'}});
    assertThat(queued[2][1]).isEqualTo('registration_completed');
- name: lowercases an uppercase sha256 digest
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: false,
      emailSha256: 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertApi('sha256').wasNotCalled();
    assertThat(queued[1][1]).isEqualTo({
      pixelId: 'px_123',
      user: {
        email_sha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
      }
    });
- name: rejects invalid custom event names
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'custom',
      customEventName: 'invalid custom event!',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertApi('gtmOnFailure').wasCalled();
    assertApi('injectScript').wasNotCalled();

    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'custom',
      customEventName: '',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertApi('injectScript').wasNotCalled();
    assertThat(queued).hasLength(0);
- name: lowercases custom event names and keeps standard names reserved
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'custom',
      customEventName: ' Quote_Requested ',
      planId: 'pro_monthly',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(3);
    assertThat(queued[2][1]).isEqualTo('custom');
    assertThat(queued[2][2]).isEqualTo({type: 'custom', plan_id: 'pro_monthly'});
    assertThat(queued[2][3]).isEqualTo({custom_event_name: 'quote_requested'});

    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'custom',
      customEventName: 'App_Opened',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(3);
    assertApi('gtmOnFailure').wasCalled();
- name: initializes a pixel once and accepts late user data
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'lead_created',
      respectGtmConsent: false,
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'registration_completed',
      respectGtmConsent: false,
      emailSha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(4);
    assertThat(queued[0][0]).isEqualTo('init');
    assertThat(queued[0][1]).isEqualTo({pixelId: 'px_123'});
    assertThat(queued[1][0]).isEqualTo('measure');
    assertThat(queued[2][0]).isEqualTo('init');
    assertThat(queued[2][1]).isEqualTo({
      pixelId: 'px_123',
      user: {email_sha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'}
    });
    assertThat(queued[3][0]).isEqualTo('measure');
- name: targets late user data when multiple pixels are initialized
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: false,
      respectGtmConsent: false,
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });
    runCode({
      pixelId: 'px_456',
      sendEvent: false,
      respectGtmConsent: false,
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'registration_completed',
      eventId: 'evt_1',
      respectGtmConsent: false,
      emailSha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued).hasLength(4);
    assertThat(queued[2][0]).isEqualTo('init');
    assertThat(queued[2][1]).isEqualTo({
      pixelId: 'px_123',
      user: {email_sha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'}
    });
    assertThat(queued[3][0]).isEqualTo('measureSingle');
    assertThat(queued[3][1]).isEqualTo('px_123');
    assertThat(queued[3][2]).isEqualTo('registration_completed');
    assertThat(queued[3][3]).isEqualTo({type: 'customer_action'});
    assertThat(queued[3][4]).isEqualTo({event_id: 'evt_1'});
- name: forces measureSingle when the tag targets one pixel
  code: |-
    runCode({
      pixelId: 'px_123',
      sendEvent: true,
      eventName: 'order_created',
      eventId: 'order_12345',
      optOut: 'false',
      pixelTargeting: 'single',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    assertThat(queued[2][0]).isEqualTo('measureSingle');
    assertThat(queued[2][1]).isEqualTo('px_123');
    assertThat(queued[2][2]).isEqualTo('order_created');
    assertThat(queued[2][3]).isEqualTo({type: 'contents'});
    assertThat(queued[2][4]).isEqualTo({event_id: 'order_12345', opt_out: false});
- name: keeps measure for every pixel when targeting is all
  code: |-
    runCode({
      pixelId: 'px_a',
      sendEvent: false,
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });
    runCode({
      pixelId: 'px_b',
      sendEvent: true,
      eventName: 'page_viewed',
      pixelTargeting: 'all',
      gtmOnSuccess: function() {},
      gtmOnFailure: function() {}
    });

    const lastCall = queued[queued.length - 1];
    assertThat(lastCall[0]).isEqualTo('measure');
    assertThat(lastCall[1]).isEqualTo('page_viewed');
setup: |-
  const templateValues = {};
  let queued = [];
  let oaiq;
  const consentState = {ad_storage: true, ad_user_data: true};
  const consentListeners = {};

  mock('getContainerVersion', function() {
    return {debugMode: false, previewMode: false};
  });
  mock('isConsentGranted', function(consentType) {
    return consentState[consentType] !== false;
  });
  mock('addConsentListener', function(consentType, callback) {
    if (!consentListeners[consentType]) {
      consentListeners[consentType] = [];
    }
    consentListeners[consentType].push(callback);
  });
  mock('copyFromWindow', function(path) {
    assertThat(path).isEqualTo('oaiq');
    return oaiq;
  });
  mock('createArgumentsQueue', function(fnKey, arrayKey) {
    assertThat(fnKey).isEqualTo('oaiq');
    assertThat(arrayKey).isEqualTo('oaiq.queue');
    oaiq = function(command, arg1, arg2, arg3, arg4) {
      queued.push([command, arg1, arg2, arg3, arg4]);
    };
    return oaiq;
  });
  mock('callInWindow', function(path, command, arg1, arg2, arg3, arg4) {
    assertThat(path).isEqualTo('oaiq');
    oaiq(command, arg1, arg2, arg3, arg4);
  });
  mock('injectScript', function(url, onSuccess, onFailure, cacheToken) {
    onSuccess();
  });
  mockObject('templateStorage', {
    getItem: function(key) {
      return templateValues[key];
    },
    setItem: function(key, value) {
      templateValues[key] = value;
    },
    removeItem: function(key) {
      templateValues[key] = undefined;
    },
    clear: function() {}
  });

  const grant = function(consentType) {
    consentState[consentType] = true;
    const registered = consentListeners[consentType] || [];
    const listeners = [];
    for (let i = 0; i < registered.length; i += 1) {
      listeners.push(registered[i]);
    }
    for (let i = 0; i < listeners.length; i += 1) {
      listeners[i](consentType, true);
    }
  };

___NOTES___

Enhanced community fork of the OpenAI Ads Measurement Pixel GTM template. Adds Google Consent Mode integration with a no-storage-before-consent default, every documented user matching field with optional in-browser normalization and SHA-256 hashing, dynamic contents variables, explicit multi-pixel targeting, one initialization per Pixel ID per page, non-blocking user data validation, and an expanded test suite.


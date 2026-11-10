# Angel's Nest task board

Updated: November 10, 2026.

## How this board works

Tasks move between the three sections below. Checkboxes track progress within a task:

- `[ ]` = still needs work.
- `[x]` = verified complete.

Move a task to **In progress** when work starts, and to **Complete** only when its entire acceptance checklist passes. Keep its task ID when moving it. Record delivery separately: **Local**, **Pushed to GitHub**, or **Deployed**. A completed local change is not automatically live on the website.

Review this board at the start and end of each work session. This is a Markdown task board; its status is updated by editing the file, not automatically by GitHub.

## In progress

### AN-01: Replace demo intent routing with Gemini

The response schema and its tests exist. The schema is not wired to Gemini or the home screen yet.

1. **Next:** Write the Gemini intent prompt and provider adapter. Use a mocked provider to check one example of each intent and an ambiguous message.
2. Add a database-free guest endpoint with bounded input/history, rate limits, and validated model output. Keep existing authenticated endpoints protected.
3. Connect the home prompt through ApiService. Keep clarification and corrections inline, and show a retry state on failure.
4. Verify the full guest flow with a live Gemini smoke test before enabling it.

Done when:
- [x] The response schema accepts volunteer, help, exchange, or unclear and rejects malformed responses.
- [ ] The provider adapter, guest endpoint, and home prompt pass automated checks.
- [ ] Live guest routing works without a database; the backend keeps the Gemini key private.

## To do


### AN-02: Replace scripted chat replies

Dependency: AN-01.

Done when:
- [ ] Responses address the actual conversation and remember context within the session.
- [ ] Follow-up questions gather relevant missing details for each journey.
- [ ] Corrections replace earlier facts; unknown details are not invented.
- [ ] Retries, duplicate sends, resets, and provider failures behave predictably.
- [ ] Scripted replies are removed from the real chat path; live behavior is accurately labeled.
- [ ] Conversation tests and live checks pass for all three journeys.

### AN-03: Define structured journey drafts and review

Dependency: AN-02. An initial help schema exists but needs live validation and expansion.

Done when:
- [ ] Help drafts capture need, timing, general location, and remote/in-person preference.
- [ ] Volunteer drafts capture offered skills, availability, and service area.
- [ ] Exchange drafts capture the offering, desired return, and expiration.
- [ ] Users can review and correct drafts before confirming submission.
- [ ] Backend validation rejects malformed fields; tests cover unknown and corrected facts.

### AN-04: Repair and verify database persistence

Dependencies: working Tiger Data credentials; AN-03 for final draft persistence.

Done when:
- [ ] Connection succeeds with verified TLS and the development schema is applied.
- [ ] Confirmed drafts save once, survive reloads, and can be retrieved and edited by their owner.
- [ ] Ownership uses Auth0 sub; guest requests cannot impersonate account holders.
- [ ] Transactions and constraints prevent duplicate or inconsistent writes.
- [ ] Live save/read/update checks pass; demo seed data is distinct from real records.

### AN-05: Define guest and account boundaries

Dependencies: product decision; implement alongside AN-01 and before publishing features.

Done when:
- [ ] Guests can explore and chat without mandatory sign-in.
- [ ] Document which actions require an account: publishing, contacting others, saving drafts, and managing offers.
- [ ] The backend enforces those decisions independently of the interface.
- [ ] Signing in preserves a guest draft through a tested handoff.
- [ ] Guest/first-name greetings, logout, expired sessions, and unauthorized access are tested.

### AN-06: Make volunteering functional

Dependencies: AN-04 and AN-05.

Done when:
- [ ] Real listings support browsing, filters, details, creation, editing, and closing.
- [ ] Users can express interest and view accurate application status.
- [ ] Owners control their listings; applicants cannot access others' private information.
- [ ] Fictional offerings leave the production path; loading, empty, and error states work.
- [ ] The listing-to-interest flow passes end-to-end checks.

### AN-07: Make Service Exchange functional

Dependencies: AN-04 and AN-05.

Done when:
- [ ] Offers and proposals persist with both services and expiration.
- [ ] Users can compare, accept, or decline eligible proposals.
- [ ] Only the authorized party can change an offer or proposal's state.
- [ ] Expired, withdrawn, or already accepted offers cannot be accepted again.
- [ ] Concurrent acceptance and reload behavior pass tests.

### AN-08: Make Community functional

Dependencies: AN-04 and AN-05.

Done when:
- [ ] Posts, comments, bookmarks, and profiles persist with owner permissions.
- [ ] Users can create, edit, and delete their own eligible content.
- [ ] Reporting and moderation exist before public posting is enabled.
- [ ] Pagination, loading, empty, and error states work.
- [ ] Persistence and cross-user permission tests pass.

### AN-09: Prepare for public use and deployment

Dependencies: features chosen for the release. Apply privacy and abuse controls throughout development.

Done when:
- [ ] Define conversation retention, deletion, and explicit sharing of private information.
- [ ] Public listings and logs exclude private data; AI usage limits and monitoring are configured.
- [ ] Check keyboard navigation, screen-reader labels, contrast, mobile keyboards, scrolling, and light/dark layouts.
- [ ] Staging passes end-to-end checks with real authentication and API configuration.
- [ ] Documentation describes the actual implementation and its limitations.
- [ ] Production deployment is explicitly authorized. Current instruction: do not deploy yet.

## Complete

### AN-C01: Optional sign-in and responsive home

- [x] Guests enter directly as neighbor; signed-in users retain first-name greetings.
- [x] Desktop/mobile layouts follow the sketch with service icons and a rounded prompt.
- [x] Community, optional sign-in, profile, and theme controls remain accessible.
- [x] Behavior checks pass.

Delivery: **Pushed to GitHub**, commit `a6a5ae5`. Not deployed as part of this change.

### AN-C02: Retire the hackathon demo

- [x] Keep guest entry, the responsive home, and inline help.
- [x] Remove scripted chat, keyword routing, fictional posts, and simulated trades.
- [x] Retain the authenticated help client; show a clear guest unavailable state.
- [x] Exclude development seed listings from the application endpoints.
- [x] Track the replacement features in AN-01 through AN-09.

The hosted hackathon site is a separate deployment.

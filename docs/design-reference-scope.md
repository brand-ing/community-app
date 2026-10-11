# Angel’s Nest — design reference scope

The supplied ten-screen reference guides the current visual design: navy serif headings, a blue-accented wordmark, white surfaces, the Making Living Easier tagline, soft lavender/blue/mint/peach category cards, compact listing cards, and rounded controls. The same visual language has a dark-mode variant. Lora is bundled locally for consistent serif typography on web, Android, and iOS; its license is in app/assets/fonts/OFL.txt. Source: https://github.com/google/fonts/tree/main/ofl/lora.

## Existing experience
- Public product page and Auth0 sign-in entry.
- Home service selection with first-name greeting and basic profile dialog.
- I need help → guided Chat with Angel preview (not AI-connected or saved).
- Volunteer offerings and paid-task categories with example listings and detail dialogs.
- Home has three service choices: I want to volunteer, I need help, and Service Exchange, plus the user-requested Community button under the heading. Quick-money categories remain inside the existing volunteer page; Angel chat opens only through I need help.
- App-wide light/dark toggle, held for the current session.

## Reference features still to build
- Live listings, search, location/date/urgency filters, opportunity posting and applications.
- Persisted Service Exchange offers and replies, real participants, notifications, and backend enforcement of expiration. The local mockup already supports an example expiring offer, creating a new offer, role switching, multiple counter-offerings, comparison cards, and accept/decline states.
- Angel Match browsing/swiping, favorites, matching criteria, and match confirmation.
- Person-to-person chat, saved conversations, attachments, scheduling, and notifications.
- AI responses through an authenticated backend route.
- Live Community publishing, moderation, and persistence. The local Community preview now has Stories, Tips, Announcements, article reading, comments, follows, likes, bookmarks, and a new-post form.
- Full profile editing, photos, skills/interests, ratings, and verified activity statistics.
- Navigation for those future sections. No inactive tabs or simulated statistics were added.

Example listing content remains explicitly labeled. Existing Auth0 settings, API flow, secrets, and backend routes are unchanged.

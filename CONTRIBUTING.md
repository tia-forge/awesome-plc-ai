# Contributing

Thanks for helping. This list exists to save engineers time, so the bar is simple: **an entry must be something a PLC engineer can actually use, and a reader must be able to judge it in one line.**

Read the [inclusion criteria](#inclusion-criteria) before opening a pull request — most rejected entries fail on criterion 1 or 4.

## Inclusion criteria

1. **Usable, not promised.** The entry must be something that exists and works today: a repository you can clone, a package you can install, a product with a public page and a way to get it. Announcements, waitlists with no product, and "coming soon" pages are out.
2. **About PLC engineering.** Writing, reviewing, verifying, documenting, simulating or operating PLC-based control code (TIA Portal, CODESYS, TwinCAT, Studio 5000, GX Works, IEC 61131-3 toolchains, OPC UA and S7 runtime access). General SCADA/MES analytics, robot learning and factory-wide AI platforms are out of scope.
3. **A stable public link.** Official site, repository or documentation — not a LinkedIn post, a forum thread, a download mirror or a URL shortener. The link should still make sense in a year.
4. **A stated licence.** Open source: name the SPDX id. Source-available with no licence: say so explicitly, because readers need to know they cannot reuse the code. Closed source: say "Commercial".
5. **Verified within the last 12 months.** A human (you) has opened the link and confirmed that the thing described is what the entry says it is. The review date is recorded in the Review log.
6. **Descriptive, not promotional.** Describe capability and limits. No superlatives, no pricing tables, no "revolutionary", no comparisons invented for the entry.

## Entry format

Add one item to the most specific section, in this shape:

```markdown
- [Name](https://example.com/) - Open source (MIT), ~120★. One or two sentences: what it does, which vendor tool or language it targets, and what it cannot do. Platform notes (Windows only, on-premises) go last.
```

- Item names link to the project, website or repository. One link per item, in the name.
- Descriptions never contain links, prices, discount codes or calls to action.
- Descriptions must not begin with the item's own name (the linter rejects `- [TwinCAT](…) - TwinCAT CoAgent …`).
- Star counts are rounded, dated by the Review log, and optional for closed-source products.
- Write in English. A short note that documentation is in Chinese is fine and useful (`Documentation is in Chinese.`).
- Keep the list alphabetically unsorted on purpose: new entries go at the end of their section. Sections are ordered by usefulness to a working engineer, not by vendor prestige.

## What gets rejected

- **Your own product added without disclosure.** Say in the pull request that it is yours. Disclosed vendor entries are fine; undeclared ones are removed.
- **A repository that only distributes binaries.** "On GitHub" is not the same as "open source". It may still be listed, but it must be described as source-available or commercial.
- **Duplicate tools under a new name.** If it is a fork or a wrapper, say so in the description.
- **Dead or paywalled-without-a-page links.** If a reader cannot see what the thing is without signing up, it does not belong here.
- **More than two entries from one maintainer or one vendor in one section.** The list is not an inventory.

## Reviewing and maintenance

- A full review is run at least quarterly: every link is opened, star counts and licences are refreshed, closed products are checked for death or acquisition, and new sections are considered.
- Each review adds an entry to the Review log at the end of `README.md`.
- Entries whose product has been discontinued are removed, not commented out. Entries whose repository has been archived keep a note saying so.
- Run the linter before submitting, and `bash scripts/check-links.sh` if you touched more than a couple of links. Both also run in CI.

### Running the linter locally

```bash
npx --yes awesome-lint README.md
```

Pass the filename as a **relative** path. With an absolute Windows path (`D:\...\README.md`), awesome-lint's URL detection mistakes the drive letter for a protocol and aborts with `Invalid GitHub repo URL`. That is a tool quirk, not a problem with the list.

## Pull request checklist

```markdown
- [ ] One entry added, in the most specific section, at the end of that section
- [ ] Link opened and verified by me today
- [ ] Licence stated (SPDX id, "source-available", or "Commercial")
- [ ] Description says what it does and what it does not do
- [ ] I have disclosed any affiliation with the product
```

## Disagreements

If an entry misdescribes your product, open an issue with the correction and a source; corrections to the description are applied on merit without requiring a payment, a partnership or a favour in return. If you believe an entry should be removed, say why in the issue — factual inaccuracy, discontinued product, licence misstatement or spam are all valid reasons.

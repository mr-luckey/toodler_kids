# Play Families Policy compliance notes for KidsLearnPlay

- **No ads** in child-facing experience
- **No personal data collection** — all progress stored locally via Hive
- **Parent gate** required for settings/dashboard (math question)
- **No social features** or external links in kid mode
- **COPPA aligned** — no account creation for children
- **Immersive gameplay** — no third-party SDKs in kid flow

## Android Release Checklist

- [x] Package ID: `com.kidslearnplay.toddler.games`
- [x] Min SDK 24
- [x] App label: KidsLearnPlay
- [ ] Signing config for Play Store release
- [ ] App Bundle (AAB) with asset delivery for Phase 2+ zones
- [ ] Performance profiling on mid-range devices (Drawing Den 60fps target)

## Asset Delivery Strategy

Phase 1 bundle: core zones + 50 drawing templates (~50MB)
Phase 2+: on-demand modules for dinosaurs, space, sports via Play Asset Delivery

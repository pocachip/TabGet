# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
cd tabget-app
npm run dev      # 개발 서버 (localhost:5173)
npm run build    # 프로덕션 빌드
npm run preview  # 빌드 결과 미리보기
```

## Project Structure

```
tabget-app/          # Vite + React 앱
  src/
    App.jsx          # 메인 컴포넌트 (전체 앱 로직)
    main.jsx         # React 진입점
    index.css        # Tailwind 4 + 글로벌 스타일
  vite.config.js     # @tailwindcss/vite 플러그인 설정
```

## Project Overview

TabGet is a mobile-first product comparison voting app. Users see two products side-by-side and vote by double-tapping. Up to 5 comparison sets roll in sequence, each with a countdown timer.

## Core Features (from spec)

1. **Real-time visual feedback** — voted side gets opacity-100 + saturation boost + border highlight; non-voted side gets opacity-30 + blur(4px) + grayscale. Pre-vote: both sides at opacity-100.

2. **Swipe navigation (mobile)** — `onTouchStart`/`onTouchEnd` with `deltaX` threshold: left swipe → `nextSet()`, right swipe → `prevSet()`. Use Framer Motion for slide transitions.

3. **Hybrid responsive layout** — Portrait mode: left/right split (`flex-row`). Landscape mode: top/bottom split (`flex-col`). Detect via `window.onresize` or `matchMedia`, stored as `isPortrait` state.

4. **Countdown timer** — per-set `endTime` timestamp, `setInterval` updates every second. Format: `HH : mm : ss`. At 0: block voting and auto-display Winner emblem.

5. **Interaction details**
   - Double-tap to vote → heart animation + haptic feedback (`navigator.vibrate`)
   - Center overlay: live participant count + vote percentage bar
   - Max 5 sets in rolling structure
   - Dual-video audio: boost volume on the side the user last touched/focused

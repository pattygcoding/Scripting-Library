<script setup lang="ts">
import EmptyState from "./components/EmptyState.vue";
import HomeView from "./components/HomeView.vue";
import LanguageView from "./components/LanguageView.vue";
import ScriptView from "./components/ScriptView.vue";
import SiteBanner from "./components/SiteBanner.vue";
import { hasData } from "./store/data";
import { state } from "./store/session";

// The app is a column now: the banner across the top, then whichever screen the
// address names.  `#app` is that column (display/height/overflow in
// src/styles/app.css), so the three children below must stay siblings.
</script>

<template>
    <SiteBanner />
    <template v-if="hasData">
        <ScriptView v-if="state.view === 'script'" />
        <LanguageView v-else-if="state.view === 'language'" />
        <HomeView v-else />
    </template>
    <main v-else class="flex-1 min-h-0 overflow-hidden p-3 sm:p-6 flex flex-col">
        <EmptyState />
    </main>
</template>

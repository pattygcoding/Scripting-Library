<script setup lang="ts">
import { computed } from "vue";
import { goHome, homeUrl, intercept, languageCards, languageUrl, openLanguage, repoHomeUrl, state } from "../store/session";
import { toggleTheme } from "../store/theme";

// The banner across the top of every screen: the way home, the six language types as
// links, and the repository on GitHub.  It replaces the sidebar the first version had,
// so the same navigation is one tap away from the home page, a language page and a
// script page alike.
//
// Every entry is a real <a href> built from the same address helpers the cards use, so
// it can be copied, bookmarked or opened in a new tab; a plain left click moves the
// view instead of reloading.
const homeActive = computed<boolean>(() => state.view === "home");

function goHomeClick(event: MouseEvent): void {
    intercept(event, goHome);
}

function goLanguage(event: MouseEvent, slug: string): void {
    intercept(event, () => openLanguage(slug));
}
</script>

<template>
    <header class="shrink-0 bg-ink-900/90 backdrop-blur border-b border-line/5">
        <div class="px-3 sm:px-5 py-2.5 flex items-center gap-3">
            <!-- The brand is the way home from anywhere. -->
            <a :href="homeUrl()" @click="goHomeClick" title="Scripting Library - home"
               :class="['flex items-center gap-2 shrink-0 rounded-md px-2 py-1.5 transition',
                        homeActive ? 'text-accent' : 'text-fg-soft hover:text-accent']">
                <span class="flex" aria-hidden="true">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" /><polyline points="9 22 9 12 15 12 15 22" /></svg>
                </span>
                <span class="text-sm font-semibold tracking-tight whitespace-nowrap">Scripting <span class="text-accent">Library</span></span>
            </a>

            <!-- The language types.  One row that scrolls sideways on a phone rather
                 than wrapping, so the banner stays one bar tall. -->
            <nav aria-label="Languages"
                 class="flex items-center gap-1 min-w-0 overflow-x-auto menu-scroll">
                <a v-for="group in languageCards" :key="group.slug"
                   :href="languageUrl(group.slug)"
                   :aria-current="group.slug === state.languageSlug ? 'page' : undefined"
                   :title="group.description"
                   :class="['shrink-0 rounded-md px-2.5 py-1.5 text-xs font-medium whitespace-nowrap border transition',
                            group.slug === state.languageSlug
                                ? 'text-accent bg-accent/10 border-accent/30'
                                : 'text-fg-muted border-transparent hover:text-fg hover:bg-line/5']"
                   @click="goLanguage($event, group.slug)">{{ group.name }}</a>
            </nav>

            <div class="ml-auto flex items-center gap-2 shrink-0">
                <!-- The library itself, which the README calls the Scripting-Library. -->
                <a :href="repoHomeUrl" :title="repoHomeUrl" target="_blank" rel="noopener"
                   aria-label="Open the Scripting-Library repository on GitHub"
                   class="flex items-center gap-1.5 rounded-md px-2 py-1.5 text-xs font-medium text-fg-muted border border-line/10 hover:text-accent hover:border-accent/40 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M15 22v-4a4.8 4.8 0 0 0-1-3.5c3 0 6-2 6-5.5.08-1.25-.27-2.48-1-3.5.28-1.15.28-2.35 0-3.5 0 0-1 0-3 1.5-2.64-.5-5.36-.5-8 0C6 2 5 2 5 2c-.3 1.15-.3 2.35 0 3.5A5.403 5.403 0 0 0 4 9c0 3.5 3 5.5 6 5.5-.39.49-.68 1.05-.85 1.65-.17.6-.22 1.23-.15 1.85v4" /><path d="M9 18c-4.51 2-5-2-7-2" /></svg>
                    <span class="hidden sm:inline">Scripting-Library</span>
                </a>
                <button type="button" @click="toggleTheme()" title="Switch colour theme" aria-label="Switch colour theme"
                        class="flex items-center justify-center w-8 h-8 rounded-md bg-ink-950 border border-line/10 text-fg-muted hover:text-accent hover:border-accent/40 transition">
                    <span class="theme-icon-sun flex" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="4" /><path d="M12 2v2" /><path d="M12 20v2" /><path d="m4.93 4.93 1.41 1.41" /><path d="m17.66 17.66 1.41 1.41" /><path d="M2 12h2" /><path d="M20 12h2" /><path d="m6.34 17.66-1.41 1.41" /><path d="m19.07 4.93-1.41 1.41" /></svg>
                    </span>
                    <span class="theme-icon-moon flex" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z" /></svg>
                    </span>
                </button>
            </div>
        </div>
    </header>
</template>
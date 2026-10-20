<script setup lang="ts">
import { computed } from "vue";
import { currentLanguage, goHome, homeUrl, intercept, languageDocs, repoLanguageUrl, searchPlaceholder, setQuery, state, visibleScripts } from "../store/session";
import ScriptCard from "./ScriptCard.vue";

// One language's page: everything its folder holds, as cards, with the folder's own
// README available underneath.  The search box here filters just this folder.
const group = computed(() => currentLanguage.value);

function homeClick(event: MouseEvent): void {
    intercept(event, goHome);
}
</script>

<template>
    <main class="flex-1 min-h-0 overflow-y-auto">
        <div class="mx-auto w-full max-w-6xl px-3 sm:px-6 py-6 sm:py-8">
            <nav aria-label="Breadcrumb" class="micro text-fg-dim flex items-center gap-2">
                <a :href="homeUrl()" class="hover:text-accent transition" @click="homeClick">Home</a>
                <span aria-hidden="true">/</span>
                <span class="text-fg-soft">{{ group?.name ?? "" }}</span>
            </nav>

            <header class="mt-4 flex items-start gap-4">
                <span class="mt-1 w-1 self-stretch rounded-full shrink-0" :style="{ backgroundColor: group?.color }" aria-hidden="true"></span>
                <div class="min-w-0">
                    <div class="flex items-center gap-3 flex-wrap">
                        <h1 class="text-2xl sm:text-3xl font-semibold tracking-tight text-fg-strong">{{ group?.name }}</h1>
                        <span v-if="group" class="lang-tag" :title="group.name + ' scripts'">{{ group.extension }}</span>
                        <span class="micro text-fg-dim">{{ group?.count }} script{{ group?.count === 1 ? "" : "s" }}</span>
                    </div>
                    <p class="mt-2 text-sm leading-relaxed text-fg-soft max-w-3xl">{{ group?.description }}</p>
                    <a v-if="repoLanguageUrl" :href="repoLanguageUrl" :title="repoLanguageUrl" target="_blank" rel="noopener"
                       class="mt-2 inline-flex items-center gap-1.5 text-[11px] font-mono text-fg-dim hover:text-accent transition">
                        <span class="flex shrink-0" aria-hidden="true">
                            <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 22v-4a4.8 4.8 0 0 0-1-3.5c3 0 6-2 6-5.5.08-1.25-.27-2.48-1-3.5.28-1.15.28-2.35 0-3.5 0 0-1 0-3 1.5-2.64-.5-5.36-.5-8 0C6 2 5 2 5 2c-.3 1.15-.3 2.35 0 3.5A5.403 5.403 0 0 0 4 9c0 3.5 3 5.5 6 5.5-.39.49-.68 1.05-.85 1.65-.17.6-.22 1.23-.15 1.85v4" /><path d="M9 18c-4.51 2-5-2-7-2" /></svg>
                        </span>
                        <span class="truncate min-w-0">View {{ group?.folder }} on GitHub</span>
                    </a>
                </div>
            </header>

            <div class="mt-6">
                <input type="search" :placeholder="searchPlaceholder" :value="state.query"
                       :aria-label="'Search ' + (group?.name ?? '') + ' scripts'"
                       @input="setQuery(($event.target as HTMLInputElement).value)"
                       class="w-full sm:max-w-md bg-ink-900 border border-line/10 rounded-md px-3 py-2.5 text-sm text-fg
                              placeholder:text-hint focus:outline-none focus:border-accent/60 focus:ring-1 focus:ring-accent/20 transition" />
            </div>

            <div v-if="visibleScripts.length" class="mt-4 grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                <ScriptCard v-for="item in visibleScripts" :key="item.id" :item="item" />
            </div>
            <p v-else class="mt-6 text-sm text-fg-muted">
                {{ state.query.trim() ? "No scripts in this folder match that search." : "This folder holds no scripts yet." }}
            </p>

            <!-- The folder's own README: the overview that sits above the individual
                 scripts on GitHub, kept behind a toggle so the cards lead the page. -->
            <details v-if="languageDocs" class="mt-8 rounded-lg bg-ink-900 border border-line/5 overflow-hidden">
                <summary class="px-4 py-3 cursor-pointer text-sm font-medium text-fg-soft hover:text-accent transition">
                    Read the {{ group?.name }} folder README
                </summary>
                <pre class="max-h-[32rem] overflow-auto border-t border-line/5 bg-ink-850 p-4 font-mono text-[12.5px] leading-relaxed text-fg-soft whitespace-pre-wrap break-words">{{ languageDocs }}</pre>
            </details>
        </div>
    </main>
</template>
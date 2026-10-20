<script setup lang="ts">
import { computed } from "vue";
import type { TabId } from "../types";
import { currentItem, repoFolderName, repoUrl, showDocsTab, state, switchTab } from "../store/session";

// The header of one script's page: which script, which language, where it lives, and
// the two views of it.  The banner above already carries the theme toggle and the
// navigation, so this header is only about the script on screen.

const title = computed<string>(() => currentItem.value?.name ?? "Select a script");

const subtitle = computed<string>(() =>
    currentItem.value ? currentItem.value.language + " script" : "No script selected",
);

// The repo link reads as a label rather than a URL, and names the folder it points
// at inside the project the data came from.
const repoLabel = computed<string>(() =>
    repoFolderName.value ? "View " + repoFolderName.value + " on GitHub" : "",
);

const extension = computed<string>(() => currentItem.value?.extension ?? "");

// The active tab keeps its filled look; the other stays muted.
function tabClass(tab: TabId): string {
    return "px-4 py-1.5 rounded text-sm font-medium transition " +
        (state.tab === tab ? "bg-mint-400 text-on-accent" : "text-fg-muted hover:text-fg");
}
</script>

<template>
    <header class="shrink-0 bg-ink-900/80 backdrop-blur border-b border-line/5 px-4 sm:px-5 py-4 flex flex-wrap gap-3 justify-between items-center">
        <div class="min-w-0">
            <p class="micro text-fg-dim">Selected script</p>
            <h2 class="mt-1.5 text-lg font-semibold tracking-tight truncate text-fg-strong">{{ title }}</h2>
            <p class="mt-0.5 text-xs text-fg-muted">{{ subtitle }}</p>
            <p class="mt-0.5 text-xs text-fg-muted font-mono truncate">{{ currentItem?.file ?? "" }}</p>
            <a v-if="repoUrl" :href="repoUrl" :title="repoUrl" target="_blank" rel="noopener"
               class="mt-1.5 inline-flex items-center gap-1.5 max-w-full text-[11px] font-mono text-fg-dim hover:text-accent transition">
                <span class="shrink-0 flex" aria-hidden="true">
                    <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 22v-4a4.8 4.8 0 0 0-1-3.5c3 0 6-2 6-5.5.08-1.25-.27-2.48-1-3.5.28-1.15.28-2.35 0-3.5 0 0-1 0-3 1.5-2.64-.5-5.36-.5-8 0C6 2 5 2 5 2c-.3 1.15-.3 2.35 0 3.5A5.403 5.403 0 0 0 4 9c0 3.5 3 5.5 6 5.5-.39.49-.68 1.05-.85 1.65-.17.6-.22 1.23-.15 1.85v4" /><path d="M9 18c-4.51 2-5-2-7-2" /></svg>
                </span>
                <span class="truncate min-w-0">{{ repoLabel }}</span>
            </a>
            <!-- The blue file-extension tag, so the header and the cards identify the
                 language the same way. -->
            <div v-if="extension" class="mt-2 flex flex-wrap gap-1.5">
                <span class="lang-tag" :title="currentItem?.name">{{ extension }}</span>
            </div>
        </div>
        <div class="flex flex-wrap items-center gap-3">
            <div class="flex flex-wrap gap-1 bg-ink-900 border border-line/5 p-1 rounded-md">
                <button type="button" @click="switchTab('code')" :class="tabClass('code')">Source Code</button>
                <button v-if="showDocsTab" type="button" @click="switchTab('docs')" :class="tabClass('docs')">Documentation</button>
            </div>
        </div>
    </header>
</template>

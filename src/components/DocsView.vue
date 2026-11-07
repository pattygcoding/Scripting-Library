<script setup lang="ts">
import { computed, ref } from "vue";
import { renderMarkdown } from "../markdown";
import { currentItem, docsText } from "../store/session";

// The README the script's own folder carries, rendered to HTML by src/markdown.ts
// (a small CommonMark subset - no dependency beyond Vue).
const renderedDocs = computed<string>(() => renderMarkdown(docsText.value));

const copied = ref(false);
let copyTimer: number | undefined;

async function copyDocs(): Promise<void> {
    if (!navigator.clipboard?.writeText) {
        return;
    }
    try {
        await navigator.clipboard.writeText(docsText.value);
    } catch {
        return;   // refused (insecure context or permissions): leave the icon alone
    }
    copied.value = true;
    window.clearTimeout(copyTimer);
    copyTimer = window.setTimeout(() => { copied.value = false; }, 1200);
}
</script>

<template>
    <section class="flex-1 flex flex-col min-h-0">
        <div class="flex items-center justify-between mb-2">
            <span class="micro text-fg-dim">{{ currentItem?.folder ?? "Documentation" }}/README.md</span>
            <span class="micro text-accent/70">From the script's own folder</span>
        </div>
        <div class="relative flex-1 min-h-0">
            <button type="button" @click="copyDocs()" title="Copy documentation" aria-label="Copy documentation"
                    :class="['absolute top-3 right-3 z-10 flex items-center justify-center w-8 h-8 rounded-md bg-ink-900/80 border border-line/10 backdrop-blur transition',
                             copied ? 'text-accent' : 'text-fg-muted hover:text-accent hover:border-accent/40']">
                <svg v-if="copied" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M20 6 9 17l-5-5" /></svg>
                <svg v-else xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect width="14" height="14" x="8" y="8" rx="2" ry="2" /><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2" /></svg>
            </button>
            <!-- Rendered markdown (src/markdown.ts): headings, lists, tables and code
                 blocks read like a page instead of raw CommonMark source. -->
            <div class="doc-markdown h-full overflow-auto rounded-lg bg-ink-850 border border-line/5 p-5 text-[13px] leading-relaxed text-fg-soft" v-html="renderedDocs"></div>
        </div>
    </section>
</template>

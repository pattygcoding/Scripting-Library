<script setup lang="ts">
import { currentItem, currentLanguage, goHome, homeUrl, intercept, languageUrl, openLanguage, state } from "../store/session";
import DetailHeader from "./DetailHeader.vue";
import DocsView from "./DocsView.vue";
import SourceView from "./SourceView.vue";

// One script's page: the trail back to its language, the header, and the source or
// the documentation beside it.  The code panel keeps the full height, so it is the
// panel that scrolls rather than the page.
function homeClick(event: MouseEvent): void {
    intercept(event, goHome);
}

function languageClick(event: MouseEvent): void {
    const slug = currentLanguage.value?.slug;
    if (slug) {
        intercept(event, () => openLanguage(slug));
    }
}
</script>

<template>
    <main class="flex-1 min-h-0 flex flex-col">
        <nav aria-label="Breadcrumb" class="shrink-0 flex items-center gap-2 px-4 sm:px-5 pt-3 micro text-fg-dim min-w-0">
            <a :href="homeUrl()" class="hover:text-accent transition shrink-0" @click="homeClick">Home</a>
            <span class="shrink-0" aria-hidden="true">/</span>
            <a :href="languageUrl(currentLanguage?.slug ?? '')" class="hover:text-accent transition shrink-0"
               @click="languageClick">{{ currentLanguage?.name ?? "" }}</a>
            <span class="shrink-0" aria-hidden="true">/</span>
            <span class="truncate text-fg-soft">{{ currentItem?.name ?? "" }}</span>
        </nav>
        <DetailHeader />
        <div class="flex-1 min-h-0 overflow-hidden p-3 sm:p-6 flex flex-col">
            <DocsView v-if="state.tab === 'docs'" />
            <SourceView v-else />
        </div>
    </main>
</template>
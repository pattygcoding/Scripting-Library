import { computed, reactive } from "vue";
import type { Item, TabId } from "../types";
import * as data from "./data";

export type MenuId = "language";

export interface FacetOption {
    value: string;
    label: string;
}

// ---- The address ----------------------------------------------------------------
// Every script is addressable on its own path: /bash-clear-git,
// /python-count-files.  The dashboard is a static bundle, so the path is resolved
// client-side with the History API.  A document with a null origin (file://) refuses
// path writes, so the query-string shape (?script=bash-clear-git) is used there
// instead - and that query shape is also what the deployed site's 404.html shim
// forwards, so `?script=` stays readable in both forms and older links keep working.
const APP_DIR = window.location.pathname.replace(/[^/]*$/, "");
let applyingHistory = false;

// Can this document write a path?  Probing once here, rather than discovering it
// when the first write fails, keeps the sidebar's hrefs in the right shape from the
// very first render; the temporary URL is restored in the same tick, before
// anything can observe it.
let canWritePath = (function probePathWrites(): boolean {
    const original = window.location.href;
    try {
        window.history.replaceState(window.history.state, "", APP_DIR + "__path-probe__");
    } catch {
        return false;
    }
    try {
        window.history.replaceState(window.history.state, "", original);
    } catch {
        // keep going: the probe already told us path writes are allowed
    }
    return true;
})();

interface LocationState {
    scriptId: string | null;
    tab: TabId;
    explicitTab: boolean;
}

// What the current address asks for, in either shape.  `/bash-clear-git/docs` names
// the tab on a path, `?tab=docs` names it in a query - both shapes the 404 shim
// forwards.
function locationState(): LocationState {
    const tail = window.location.pathname.slice(APP_DIR.length).replace(/\/+$/, "");
    const parts = tail ? tail.split("/") : [];
    const pathTab = parts.length === 2 && /^(code|docs)$/.test(parts[1]) ? parts[1] : "";
    // The deployment root (`/`, and the `/index.html` the 404 shim links back to)
    // names no script at all, so `parts` can be empty - read the segment defensively.
    // Anything unrecognised (`index.html`, a junk slug) is not a known script either,
    // so it falls through to `?script=` and from there to the default script.
    const first = (parts[0] ?? "").toLowerCase();
    const params = new URLSearchParams(window.location.search || "");
    const fromQuery = (params.get("script") || "").toLowerCase();
    const candidate = data.knownScript(first) ? first : fromQuery;
    const rawTab = pathTab || params.get("tab");
    return {
        scriptId: data.knownScript(candidate) ? candidate : null,
        tab: rawTab === "docs" ? "docs" : "code",
        explicitTab: !!(pathTab || params.get("tab")),
    };
}

// The address for what is on screen, in whichever shape the browser accepts.  Used
// for the sidebar's real links too, so a copied or middle-clicked link carries the
// script and the tab along.
export function stateUrl(scriptId: string, tab: TabId): string {
    const params = new URLSearchParams();
    if (!canWritePath) {
        params.set("script", scriptId);
    }
    // Addresses stay clean: name a tab only when it is not the one the script opens
    // on anyway, and never when the script cannot show it.
    if (!data.tabAvailableFor(data.itemById(scriptId), tab)) {
        tab = "code";
    }
    if (tab !== data.defaultTabFor()) {
        params.set("tab", tab);
    }
    const base = canWritePath ? APP_DIR + scriptId : window.location.pathname;
    const query = params.toString();
    return query ? base + "?" + query : base;
}

function syncUrl(mode: "push" | "replace"): void {
    if (applyingHistory || !state.scriptId) {
        return;
    }
    const url = stateUrl(state.scriptId, state.tab);
    try {
        window.history[mode === "push" ? "pushState" : "replaceState"](null, "", url);
    } catch {
        // Belt and braces: keep the query shape such a document allows.
        canWritePath = false;
        syncUrl(mode);
    }
}

// Back/forward: rebuild the view from the address without writing it again.
function applyLocation(): void {
    const target = locationState();
    applyingHistory = true;
    state.scriptId = target.scriptId ?? data.defaultScriptId();
    state.tab = target.explicitTab ? target.tab : data.defaultTabFor();
    applyingHistory = false;
}

// ---- Selection ------------------------------------------------------------------
export const state = reactive({
    scriptId: null as string | null,
    tab: "code" as TabId,
    query: "",
    language: "All",
    /** The mobile drawer: a slide-in sidebar below `lg`. */
    sidebarOpen: false,
    /** The one filter dropdown allowed open at a time. */
    openMenu: null as MenuId | null,
});

export const currentItem = computed<Item | undefined>(() => data.itemById(state.scriptId));

export const visibleItems = computed<Item[]>(() => {
    const query = state.query.trim().toLowerCase();
    return data.scripts().filter((item) => {
        const matchesLanguage = state.language === "All" || item.language === state.language;
        const haystack = (item.name + " " + item.id + " " + item.language + " " + item.file).toLowerCase();
        return matchesLanguage && (query === "" || haystack.includes(query));
    });
});

export const listMessage = computed<string>(() => {
    if (data.scripts().length === 0) {
        return "No scripts yet.";
    }
    return "No scripts match your search.";
});

export const searchPlaceholder = "Search scripts...";

export const metaLine = computed<string>(() => {
    const meta = data.DATA?.meta;
    const scriptCount = meta?.scriptCount || data.scripts().length;
    const languageCount = meta?.languageCount || data.languageGroups().length;
    const counts = scriptCount + " script" + (scriptCount === 1 ? "" : "s") +
        " \u00b7 " + languageCount + " language" + (languageCount === 1 ? "" : "s");
    return counts + " \u00b7 updated " + (meta?.updated || "n/a");
});

export const repoUrl = computed<string>(() => (currentItem.value ? data.repoUrlFor(currentItem.value) : ""));

// The repository root, behind the sidebar's GitHub mark: a real link rather than a
// per-folder one, so the whole project is one click away from every screen.
export const repoHomeUrl = computed<string>(() => data.repoHomeUrl());

export const repoFolderName = computed<string>(() => (currentItem.value ? data.repoFolder(currentItem.value) : ""));

// ---- Documentation --------------------------------------------------------------
// The README.md lives in the script's own folder, so unlike the shared console
// captures of the other showcases this tab is per script: it exists only when the
// generator found a README beside the source.
export const showDocsTab = computed<boolean>(() => data.tabAvailableFor(currentItem.value, "docs"));

export const docsText = computed<string>(() => currentItem.value?.docs ?? "");

// ---- Facets ---------------------------------------------------------------------
// One facet, because the folder a script lives in is the only grouping that is real
// data rather than a judgement call: it is what distinguishes .sh from .ps1.
export const languageOptions = computed<FacetOption[]>(() => {
    const groups = data.languageGroups();
    return [{ value: "All", label: "All languages" }].concat(
        groups.map((group) => ({ value: group.name, label: group.name + " (" + group.count + ")" })),
    );
});

// ---- Actions --------------------------------------------------------------------
export function setQuery(value: string): void {
    state.query = value;
}

export function setFacet(facet: MenuId, value: string): void {
    state[facet] = value;
}

// Move the selection and write the address.  A tap on a list row also ends that
// interaction, so the mobile drawer goes away.
export function selectScript(id: string): void {
    state.scriptId = id;
    syncUrl("push");
    state.sidebarOpen = false;
}

export function switchTab(tab: TabId): void {
    if (!data.tabAvailableFor(currentItem.value, tab)) {
        tab = "code";
    }
    const changed = state.tab !== tab;
    state.tab = tab;
    if (changed) {
        syncUrl("push");
    }
}

export function toggleSidebar(): void {
    state.sidebarOpen = !state.sidebarOpen;
}

export function closeSidebar(): void {
    state.sidebarOpen = false;
}

export function toggleMenu(id: MenuId): void {
    state.openMenu = state.openMenu === id ? null : id;
}

export function closeMenus(): void {
    state.openMenu = null;
}

// Mirror the address into the view; the address is only written at the end (the
// selection taken from the URL must not add a history entry).
export function initSession(): void {
    if (!data.hasData) {
        return;
    }
    const target = locationState();
    state.scriptId = target.scriptId ?? data.defaultScriptId();
    state.tab = target.explicitTab ? target.tab : data.defaultTabFor();
    syncUrl("replace");   // canonical address for what is on screen

    window.addEventListener("popstate", applyLocation);
}

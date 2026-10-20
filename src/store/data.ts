import type { DashboardData, Item, LanguageGroup, TabId } from "../types";

// Everything the dashboard displays, read straight from the generated payload.
// These helpers are pure lookups over `DATA` - the reactive selection on top of
// them lives in `session.ts`.
export const DATA: DashboardData | undefined = window.SCRIPTING_LIBRARY_DATA;

// A checkout that has not run the generator yet still boots and shows the empty
// state (which says how to generate the data) instead of throwing.
export const hasData: boolean = !!DATA && Array.isArray(DATA.scripts) && DATA.scripts.length > 0;

// The script the showcase falls back to when the address names none (`/` and
// `index.html` both land here).  "Clear Git" ships in all six languages, so it is
// the clearest single demonstration of what the library is; a fork without it falls
// back to the first script present.
export const DEFAULT_SCRIPT_ID = "bash-clear-git";

// The last-resort repository, for the one place a link cannot read `meta`: a
// checkout that has not generated the showcase data yet.  The generator writes the
// real one (git remote, else GITHUB_REPOSITORY, else this same default).
const DEFAULT_REPOSITORY = "https://github.com/pattygcoding/Scripting-Library";

export function scripts(): Item[] {
    return DATA?.scripts ?? [];
}

export function languageGroups(): LanguageGroup[] {
    return DATA?.languages ?? [];
}

export function itemById(id: string | null): Item | undefined {
    if (!id) {
        return undefined;
    }
    return scripts().find((item) => item.id === id);
}

export function knownScript(id: string | null | undefined): boolean {
    return !!id && scripts().some((item) => item.id === id);
}

export function defaultScriptId(): string | null {
    const all = scripts();
    return (all.find((script) => script.id === DEFAULT_SCRIPT_ID) ?? all[0])?.id ?? null;
}

// Whether a script can show a tab.  Every script has source; the documentation tab
// needs the README.md the generator read out of its folder, so the four folders that
// have none simply drop the tab.
export function tabAvailableFor(item: Item | undefined, tab: TabId): boolean {
    if (tab === "docs") {
        return !!item?.docs;
    }
    return true;
}

// The tab a script opens on.
export function defaultTabFor(): TabId {
    return "code";
}

// The folder a script lives in, used for its GitHub link.  The generator records it
// explicitly, so the header and the link never have to re-derive it from the path.
export function repoFolder(item: Item): string {
    return item.folder || (item.file || "").replace(/\/[^/]*$/, "");
}

// `<repository>/tree/<branch>/<folder>`.  Folder names here are real script names
// (`Clear Git`, `Update GIt`, `Compare Columns`), so every path segment is
// URL-encoded - a raw `#` would otherwise be read as a fragment and break the link.
export function repoUrlFor(item: Item): string {
    const repository = DATA?.meta?.repository;
    if (!repository) {
        return "";
    }
    const path = repoFolder(item).split("/").map(encodeURIComponent).join("/");
    return repository + "/tree/" + (DATA?.meta?.branch || "main") + "/" + path;
}

// The repository root itself, behind the sidebar's GitHub mark - the same generated
// `meta.repository` the per-folder links are built from, so a fork marks its own
// project.
export function repoHomeUrl(): string {
    return DATA?.meta?.repository || DEFAULT_REPOSITORY;
}

// The line-number column beside the code: one number per line, trimmed of the
// trailing blank lines a file ends with.
export function lineNumbersFor(text: string): string {
    const normalized = text.replace(/\n+$/, "");
    const count = normalized.length ? normalized.split("\n").length : 1;
    const numbers: number[] = [];
    for (let line = 1; line <= count; line += 1) {
        numbers.push(line);
    }
    return numbers.join("\n");
}

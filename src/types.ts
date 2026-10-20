// The shape of `public/scripts-data.js`, which tools/generate-data.mjs writes from
// the real repository.  Every script has the same shape, so the sidebar, the header
// and the code panel stay unaware of which language they show.

export type TabId = "code" | "docs";

export interface Item {
    /** The script's address slug, e.g. `bash-clear-git`. */
    id: string;
    /** The script's folder name, e.g. `Clear Git`. */
    name: string;
    /** The language row this script belongs to, e.g. `Bash`. */
    language: string;
    /** The Prism grammar class, e.g. `language-bash`. */
    prism: string;
    /** The source path shown above the code and linked on GitHub. */
    file: string;
    /** The script's folder - what the GitHub link points at. */
    folder: string;
    /** The file-extension tag shown in the list, e.g. `.sh`. */
    extension: string;
    /** An optional sentence shown above the code (a folder that ships more than
        one file, e.g. the spreadsheet scripts' .vba/.gs/.ts trio). */
    note?: string;
    /** The folder's README.md, shown on the Documentation tab.  Absent for the
        few folders that have none, which is what hides the tab. */
    docs?: string;
    code: string;
}

/** One language row: a folder of scripts and what identifies it. */
export interface LanguageGroup {
    name: string;
    /** The file-extension tag shown in the list, e.g. `.ps1`. */
    extension: string;
    prism: string;
    /** How many scripts the folder holds. */
    count: number;
}

export interface DataMeta {
    updated: string;
    languageCount: number;
    scriptCount: number;
    /** How many scripts ship a README.md. */
    documentedCount: number;
    repository: string;
    branch: string;
}

export interface DashboardData {
    meta: DataMeta;
    /** The language folders, in the order the repository lists them. */
    languages: LanguageGroup[];
    scripts: Item[];
}

declare global {
    interface Window {
        /** Installed by public/scripts-data.js, before the app module runs. */
        SCRIPTING_LIBRARY_DATA?: DashboardData;
    }
}

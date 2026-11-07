// Renders a README's markdown to HTML for the Documentation tab and the language
// page's folder overview.
//
// The app ships no dependency beyond Vue, and these READMEs use a small, well-defined
// slice of CommonMark, so the renderer is written here rather than pulled from a CDN.
// Crucially it escapes every byte it does not itself emit as markup: that is what
// keeps the placeholder text the READMEs use (`neovim <file-name>`, `<path-to.csproj>`)
// visible instead of being swallowed as an unknown HTML tag, and it makes the output
// safe to hand to v-html.

function escapeHtml(text: string): string {
    return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function attribute(url: string): string {
    // The text was escaped already, so only the quote that would end the attribute
    // needs handling here.
    return url.replace(/"/g, "%22");
}

// Inline markup: code spans, images, links, bold, italic, strikethrough.  Code spans
// are lifted out first, so markup-looking text inside them (`**`, `#`) stays literal.
function renderInline(text: string): string {
    let html = "";
    for (const part of text.split(/(`[^`]+`)/g)) {
        html += /^`[^`]+`$/.test(part) ? "<code>" + escapeHtml(part.slice(1, -1)) + "</code>" : renderText(part);
    }
    return html;
}

function renderText(text: string): string {
    let html = escapeHtml(text);
    // Images before links: a badge is an image wrapped in a link.
    html = html.replace(/!\[([^\]]*)\]\(([^)\s]+)\)/g, (_match, alt, src) => `<img src="${attribute(src)}" alt="${alt}" loading="lazy" />`);
    html = html.replace(/\[([^\]]+)\]\(([^)\s]+)\)/g, (_match, label, href) => `<a href="${attribute(href)}" target="_blank" rel="noopener">${label}</a>`);
    html = html.replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
    html = html.replace(/(^|[^*])\*([^*\n]+)\*/g, "$1<em>$2</em>");
    html = html.replace(/~~([^~]+)~~/g, "<del>$1</del>");
    return html;
}

const FENCE = /^```(.*)$/;
const HEADING = /^ {0,3}(#{1,6})\s+(.*?)\s*#*\s*$/;
const RULE = /^ {0,3}(?:-{3,}|\*{3,}|_{3,})\s*$/;
const QUOTE = /^ {0,3}>/;
const LIST = /^(\s*)([-*+]|\d+[.)])\s+(.*)$/;

function isBlockStart(line: string): boolean {
    return FENCE.test(line) || HEADING.test(line) || RULE.test(line) || QUOTE.test(line) || LIST.test(line);
}

function isTableSeparator(line: string): boolean {
    if (!line.includes("-")) {
        return false;
    }
    const cells = line.trim().replace(/^\||\|$/g, "").split("|");
    return cells.length > 0 && cells.every((cell) => /^\s*:?-{2,}:?\s*$/.test(cell));
}

function isTableStart(lines: string[], index: number): boolean {
    return lines[index].includes("|") && index + 1 < lines.length && isTableSeparator(lines[index + 1]);
}

function splitRow(line: string): string[] {
    let row = line.trim();
    if (row.startsWith("|")) {
        row = row.slice(1);
    }
    if (row.endsWith("|")) {
        row = row.slice(0, -1);
    }
    return row.split("|").map((cell) => cell.trim());
}

function renderTable(lines: string[], start: number): { html: string; next: number } {
    const head = splitRow(lines[start]).map((cell) => `<th>${renderInline(cell)}</th>`).join("");
    let index = start + 2;
    const body: string[] = [];
    while (index < lines.length && lines[index].includes("|") && lines[index].trim() !== "") {
        const cells = splitRow(lines[index]).map((cell) => `<td>${renderInline(cell)}</td>`).join("");
        body.push(`<tr>${cells}</tr>`);
        index += 1;
    }
    return { html: `<table><thead><tr>${head}</tr></thead><tbody>${body.join("")}</tbody></table>`, next: index };
}

function renderList(lines: string[], start: number): { html: string; next: number } {
    const ordered = /^\s*\d+[.)]\s+/.test(lines[start]);
    const baseIndent = (lines[start].match(/^(\s*)/) as RegExpMatchArray)[1].length;
    const items: string[] = [];
    let index = start;

    while (index < lines.length) {
        const line = lines[index];
        const match = line.match(LIST);
        if (!match) {
            const canContinue = items.length > 0 && /^\s+\S/.test(line) && !items[items.length - 1].includes("\n<");
            if (line.trim() === "" || !canContinue) {
                break;
            }
            items[items.length - 1] += " " + line.trim();   // a wrapped list item
            index += 1;
            continue;
        }
        if (match[1].length > baseIndent && items.length > 0) {
            const nested = renderList(lines, index);   // a sub-list hangs off the last item
            items[items.length - 1] += "\n" + nested.html;
            index = nested.next;
            continue;
        }
        items.push(match[3]);
        index += 1;
    }

    const tag = ordered ? "ol" : "ul";
    const body = items.map((item) => {
        const nested = item.indexOf("\n<");
        return nested >= 0
            ? `<li>${renderInline(item.slice(0, nested))}${item.slice(nested + 1)}</li>`
            : `<li>${renderInline(item)}</li>`;
    }).join("");
    return { html: `<${tag}>${body}</${tag}>`, next: index };
}

function renderBlocks(lines: string[]): string {
    let html = "";
    let index = 0;
    while (index < lines.length) {
        const line = lines[index];

        const fence = line.match(FENCE);
        if (fence) {
            const language = fence[1].trim();
            const code: string[] = [];
            index += 1;
            while (index < lines.length && !FENCE.test(lines[index])) {
                code.push(lines[index]);
                index += 1;
            }
            index += 1;   // the closing fence
            const cls = language ? ` class="language-${escapeHtml(language)}"` : "";
            html += `<pre><code${cls}>${escapeHtml(code.join("\n"))}</code></pre>`;
            continue;
        }

        if (line.trim() === "") {
            index += 1;
            continue;
        }

        if (RULE.test(line)) {
            html += "<hr />";
            index += 1;
            continue;
        }

        const heading = line.match(HEADING);
        if (heading) {
            html += `<h${heading[1].length}>${renderInline(heading[2])}</h${heading[1].length}>`;
            index += 1;
            continue;
        }

        if (QUOTE.test(line)) {
            const quote: string[] = [];
            while (index < lines.length && QUOTE.test(lines[index])) {
                quote.push(lines[index].replace(/^ {0,3}>\s?/, ""));
                index += 1;
            }
            html += "<blockquote>" + renderBlocks(quote) + "</blockquote>";
            continue;
        }

        if (isTableStart(lines, index)) {
            const table = renderTable(lines, index);
            html += table.html;
            index = table.next;
            continue;
        }

        if (LIST.test(line)) {
            const list = renderList(lines, index);
            html += list.html;
            index = list.next;
            continue;
        }

        const paragraph: string[] = [];
        while (index < lines.length && lines[index].trim() !== "" && !isBlockStart(lines[index]) && !isTableStart(lines, index)) {
            paragraph.push(lines[index].trim());
            index += 1;
        }
        html += "<p>" + renderInline(paragraph.join(" ")) + "</p>";
    }
    return html;
}

export function renderMarkdown(markdown: string): string {
    if (!markdown) {
        return "";
    }
    return renderBlocks(markdown.replace(/\r\n?/g, "\n").split("\n"));
}

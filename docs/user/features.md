# 📋 Synapse Features Guide

## 🎯 Overview

Synapse is packed with powerful features designed to make note-taking simple, efficient, and intelligent. This guide covers all the features available in the current version.

---

## 📝 Note Management

### Creating Notes

**How to create a new note:**

1. Tap the **+** button in the bottom right corner
2. Enter a title for your note
3. Start typing your content
4. Your note is automatically saved

**Tips:**

- Notes are saved automatically every 30 seconds
- You can create notes without an internet connection
- Each note can be up to 10,000 characters long

### Editing Notes

**How to edit an existing note:**

1. Tap on any note in the list
2. Make your changes
3. Changes are saved automatically

**Features:**

- Real-time auto-save
- Undo/redo functionality
- Version history (coming soon)

### Organizing Notes

**Sorting options:**

- **Date Modified**: Most recently updated first
- **Date Created**: Oldest first
- **Title**: Alphabetical order
- **Size**: Largest notes first

**Filtering options:**

- **All Notes**: View all notes
- **Text Notes**: Plain text only
- **Markdown Notes**: Formatted notes only
- **With Summaries**: Notes with AI summaries

---

## 🧠 AI Summarization

### Generating Summaries

**How to generate an AI summary:**

1. Open any note with content
2. Tap the **Summarize** button (📝)
3. Wait for the AI to process your content
4. View the generated summary

**What the AI can do:**

- Extract key points from long text
- Identify main topics and themes
- Provide concise overviews
- Work with multiple languages

### Summary Features

**Summary display:**

- Shows at the top of the note
- Clearly distinguished from content
- Includes generation timestamp
- Can be copied to clipboard

**Regenerating summaries:**

- Tap the refresh button next to summary
- AI will create a new summary
- Previous summaries are replaced

**Privacy:**

- Content is sent to Google Gemini AI
- No data is stored on external servers
- API calls are encrypted

---

## 📋 Markdown Support

### Markdown Basics

**Supported syntax:**

#### Headings

```markdown
# Heading 1

## Heading 2

### Heading 3
```

#### Text Formatting

```markdown
**Bold text**
_Italic text_
~~Strikethrough~~
```

#### Lists

```markdown
- Bullet list item
- Another item

1. Numbered list
2. Second item
```

#### Links

```markdown
[Link text](https://example.com)
```

#### Code

````markdown
`Inline code`

```code block
function example() {
  return "Hello World";
}
```
````

```

### Using Markdown Mode
**How to switch to Markdown:**
1. Open the editor
2. Tap the **Markdown** toggle button
3. Start typing with Markdown syntax
4. Use the preview button to see formatting

**Preview mode:**
- Tap the **Preview** button to see formatted text
- Tap **Edit** to return to editing
- Preview updates in real-time

**Tips:**
- Use `#` for main headings
- Use `##` for subheadings
- Use `-` for bullet points
- Use `**text**` for emphasis

---

## 🔍 Search & Organization

### Searching Notes
**How to search:**
1. Tap the search icon in the app bar
2. Type your search term
3. Results appear instantly
4. Tap on a result to open the note

**Search features:**
- Searches both titles and content
- Case-insensitive search
- Highlights matching text
- Shows search results in context

**Search tips:**
- Use specific keywords for better results
- Search works offline
- Results are sorted by relevance

### Filtering Notes
**Available filters:**
- **All Notes**: Show everything
- **Text Notes**: Plain text only
- **Markdown Notes**: Formatted notes
- **With Summaries**: AI-summarized notes
- **Recent**: Last 7 days
- **This Month**: Current month

**How to filter:**
1. Tap the filter icon
2. Select your filter option
3. View filtered results
4. Clear filter to see all notes

---

## 💾 Data Management

### Local Storage
**What's stored locally:**
- All your notes and content
- App settings and preferences
- Search history
- Note metadata

**Storage benefits:**
- Works completely offline
- No internet required
- Fast access to all data
- Complete privacy

### Export Options
**How to export notes:**
1. Open the Settings screen
2. Tap "Export Data"
3. Choose export format
4. Select destination

**Export formats:**
- **Text (.txt)**: Plain text format
- **Markdown (.md)**: Preserves formatting
- **JSON (.json)**: Complete data with metadata

**Sharing notes:**
- Tap the share button on any note
- Choose sharing method
- Note content is copied to clipboard
- Can be shared via any app

---

## 🎨 Customization

### Theme Settings
**Available themes:**
- **Light Mode**: Clean white background
- **Dark Mode**: Easy on the eyes
- **System Default**: Follows device setting

**How to change theme:**
1. Open Settings
2. Tap "Appearance"
3. Select your preferred theme
4. Changes apply immediately

### Font Settings
**Font size options:**
- **Small**: 12px
- **Medium**: 14px (default)
- **Large**: 16px
- **Extra Large**: 18px

**How to adjust font:**
1. Open Settings
2. Tap "Text Size"
3. Select your preferred size
4. Changes apply to all text

### Editor Preferences
**Default note type:**
- **Text**: Start with plain text
- **Markdown**: Start with Markdown mode

**Auto-save interval:**
- **15 seconds**: Frequent saves
- **30 seconds**: Default setting
- **60 seconds**: Less frequent saves

---

## 🔧 Advanced Features

### Keyboard Shortcuts
**Available shortcuts:**
- `Ctrl/Cmd + S`: Save note
- `Ctrl/Cmd + B`: Bold text (Markdown)
- `Ctrl/Cmd + I`: Italic text (Markdown)
- `Ctrl/Cmd + K`: Insert link (Markdown)
- `Ctrl/Cmd + Shift + P`: Preview mode

### Quick Actions
**From notes list:**
- **Long press**: Context menu
- **Swipe left**: Delete note
- **Swipe right**: Pin note (coming soon)

**From editor:**
- **Double tap**: Select word
- **Triple tap**: Select paragraph
- **Pinch**: Zoom in/out

### Accessibility Features
**Available options:**
- **Screen reader support**: Full compatibility
- **High contrast**: Enhanced visibility
- **Large text**: Increased font sizes
- **Voice input**: Speech-to-text (device dependent)

---

## 🔒 Privacy & Security

### Data Privacy
**What we don't collect:**
- Personal information
- Usage analytics
- Note content (except for AI summaries)
- Device information

**What we do collect:**
- App crash reports (anonymous)
- Performance metrics (anonymous)
- Feature usage (anonymous)

### Security Features
**Data protection:**
- All data encrypted at rest
- No cloud storage
- Local-only processing
- Secure API communication

**Privacy controls:**
- Clear all data option
- Export your data anytime
- No tracking or analytics
- Complete user control

---

## 🆘 Troubleshooting

### Common Issues

#### App Won't Start
**Solution:**
1. Restart your device
2. Clear app cache
3. Reinstall the app
4. Check available storage

#### Notes Not Saving
**Solution:**
1. Check available storage space
2. Restart the app
3. Check auto-save settings
4. Try manual save

#### AI Summary Not Working
**Solution:**
1. Check internet connection
2. Verify API key is set
3. Try regenerating summary
4. Check note content length

#### Search Not Finding Notes
**Solution:**
1. Check spelling
2. Try different keywords
3. Clear search and try again
4. Restart the app

### Performance Tips
**For better performance:**
- Keep notes under 5,000 characters
- Use Markdown sparingly in large notes
- Clear search history regularly
- Restart app weekly

**For battery life:**
- Use dark mode
- Reduce auto-save frequency
- Close app when not in use
- Disable unnecessary features

---

## 📞 Getting Help

### Support Channels
- **Email**: support@synapse.app
- **Documentation**: docs.synapse.app
- **Community**: community.synapse.app
- **GitHub**: github.com/synapse-app

### Feature Requests
**How to request features:**
1. Email us with your idea
2. Include detailed description
3. Explain use case
4. Provide examples if possible

### Bug Reports
**How to report bugs:**
1. Describe the issue clearly
2. Include steps to reproduce
3. Mention your device and OS
4. Attach screenshots if helpful

---

## 🔄 Future Features

### Coming Soon
- **Cloud Sync**: Optional cloud backup
- **Collaboration**: Share notes with others
- **Templates**: Pre-made note templates
- **Advanced Search**: Search within specific date ranges

### Planned Features
- **Voice Notes**: Record audio notes
- **Image Support**: Add images to notes
- **Tags**: Organize notes with tags
- **Folders**: Create note folders

### Long-term Roadmap
- **iOS Version**: Native iPhone app
- **Web Version**: Browser-based app
- **Desktop App**: Windows/Mac application
- **API Access**: Third-party integrations

---

## 📊 Feature Comparison

| Feature | Free Version | Premium (Future) |
|---------|-------------|------------------|
| Note Creation | ✅ Unlimited | ✅ Unlimited |
| Markdown Support | ✅ Full | ✅ Full |
| AI Summarization | ✅ 10/month | ✅ Unlimited |
| Local Storage | ✅ Unlimited | ✅ Unlimited |
| Search | ✅ Basic | ✅ Advanced |
| Export | ✅ Basic | ✅ Advanced |
| Cloud Sync | ❌ | ✅ |
| Collaboration | ❌ | ✅ |
| Templates | ❌ | ✅ |
| Priority Support | ❌ | ✅ |

---

**Last updated**: Version 1.0.0 - July 2024
```

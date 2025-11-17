# Refactor ChatBotViewBody TODO

- [x] Create ChatBotAppBar.dart: Extract the buildAppBar method into a separate AppBar widget.
- [x] Create MessageInput.dart: Extract \_buildMessageInput into a MessageInput widget, passing necessary controllers and callbacks.
- [x] Create MessageBubble.dart: Extract \_buildMessage into a MessageBubble widget, passing message and user data.
- [x] Create ChatSessionService.dart: Extract session-related methods (\_createNewSession, \_loadLastSession, \_loadMessages, \_saveMessage, \_showSessionList, \_showSessionChoiceDialog) into a service class.
- [x] Create GeminiService.dart: Extract Gemini-related methods (\_initializeGemini, \_sendMessage logic for Gemini) into a service class.
- [x] Refactor chat_bot_view_body.dart: Update to use the new widgets and services, injecting dependencies where needed.
- [x] Test the refactored code by running the app and verifying chat functionality.
- [x] Run flutter analyze to check for any linting issues.
- [x] Ensure all imports and dependencies are correctly handled.

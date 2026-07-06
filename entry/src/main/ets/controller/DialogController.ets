import { UIContext, PromptAction } from '@kit.ArkUI';
import { AppSize } from '../theme/AppTheme';

// Handles DialogV2 presentation (used by the Enhanced page).
// open()      -> consistent default size (most dialogs)
// openAuto()  -> no forced size, dialog fits its own content (e.g. loading)
export class DialogController {
  private promptAction: PromptAction;

  constructor(uiContext: UIContext) {
    this.promptAction = uiContext.getPromptAction();
  }

  // ---------------- Open ----------------

  open(builder: CustomBuilder): Promise<number> {
    return this.promptAction.openCustomDialog({
      builder,
      width: AppSize.DIALOG_WIDTH as Dimension,
      height: AppSize.DIALOG_HEIGHT as Dimension
    });
  }

  openAuto(builder: CustomBuilder): Promise<number> {
    return this.promptAction.openCustomDialog({
      builder
    });
  }

  // ---------------- Close ----------------

  close(dialogId: number): void {
    this.promptAction.closeCustomDialog(dialogId);
  }
}
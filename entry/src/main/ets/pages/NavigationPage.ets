import { NavigationService, Page } from '../services/NavigationService';
import { common } from '@kit.AbilityKit';
import { StandardDialogsPage } from './StandardDialogsPage';
import { EnhancedDialogsPage } from './EnhancedDialogsPage';
import GlobalContext from '../utils/GlobalContext';
import { DialogHomePage } from './DialogHomePage';


@Entry
@Component
struct NavigationPage {
  navigationService: NavigationService = NavigationService.getInstance();

  @Builder
  routeMap(name: string) {
    NavDestination() {
      if (name === Page.STANDARD_PAGE) {
        StandardDialogsPage()
      } else if (name === Page.ENHANCED_PAGE) {
        EnhancedDialogsPage()
      } else if(name === Page.HOME_PAGE){
        DialogHomePage()
      }
    }
    .onBackPressed(() => {
      if (name === Page.HOME_PAGE) {
        this.terminateApp();
        return true;
      }
      return false;
    })
    .hideTitleBar(true)
  }

  build() {
    Navigation(this.navigationService.pageInfos)
      .onAppear(() => {
        this.navigationService.clearStackAndNavigate(Page.HOME_PAGE);
      })
      .mode(NavigationMode.Stack)
      .navDestination(this.routeMap)
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.BOTTOM])
      .hideTitleBar(true)
      .width('100%')
      .height('100%')
  }

  private terminateApp() {
    const context = GlobalContext.getInstance().getCntx() as common.UIAbilityContext;
    if (context) {
      context.terminateSelf();
    }
  }
}


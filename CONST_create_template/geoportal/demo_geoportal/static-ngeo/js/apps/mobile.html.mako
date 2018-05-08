<!DOCTYPE html>
<html lang="{{mainCtrl.lang}}" ng-app="AppMobile" ng-controller="MobileController as mainCtrl">
  <head>
    <title ng-bind-template="{{'Mobile Application'|translate}}">GeoMapFish</title>
    <meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <link rel="shortcut icon" href="/${instance}/wsgi/static-ngeo/BUSTING_VERSION/images/favicon.ico')}"/>
  </head>
  <%
    no_redirect_query = dict({} if request is None else request.GET)
    no_redirect_query['no_redirect'] = u''
  %>

  <body ng-class="{'gmf-mobile-nav-is-visible': mainCtrl.navIsVisible(),
                   'gmf-mobile-nav-left-is-visible': mainCtrl.leftNavIsVisible(),
                   'gmf-mobile-nav-right-is-visible': mainCtrl.rightNavIsVisible()}">
    <main ng-class="{'gmf-search-is-active': mainCtrl.searchOverlayVisible}">
      <gmf-map
        gmf-map-map="mainCtrl.map"
        gmf-map-manage-resize="mainCtrl.manageResize"
        gmf-map-resize-transition="mainCtrl.resizeTransition"
        ngeo-map-query=""
        ngeo-map-query-map="::mainCtrl.map"
        ngeo-map-query-active="mainCtrl.queryActive"></gmf-map>
      <gmf-displayquerywindow
        gmf-displayquerywindow-featuresstyle="::mainCtrl.queryFeatureStyle"
        gmf-displayquerywindow-defaultcollapsed="false">
      </gmf-displayquerywindow>
      <div
        class="gmf-mobile-measure"
        gmf-mobile-measurelength
        gmf-mobile-measurelength-active="mainCtrl.measureLengthActive"
        gmf-mobile-measurelength-map="::mainCtrl.map">
      </div>
      <div
        class="gmf-mobile-measure"
        gmf-mobile-measurepoint
        gmf-mobile-measurepoint-active="mainCtrl.measurePointActive"
        gmf-mobile-measurepoint-layersconfig="::mainCtrl.elevationLayersConfig"
        gmf-mobile-measurepoint-map="::mainCtrl.map">
      </div>
      <button class="gmf-mobile-nav-trigger gmf-mobile-nav-left-trigger"
        ng-click="mainCtrl.toggleLeftNavVisibility()">
        <span class="gmf-icon gmf-icon-layers"></span>
      </button>
      <gmf-search gmf-search-map="::mainCtrl.map"
        gmf-search-datasources="::mainCtrl.searchDatasources"
        gmf-search-coordinatesprojections="::mainCtrl.searchCoordinatesProjections"
        gmf-search-listeners="::mainCtrl.searchListeners">
      </gmf-search>
      <button class="gmf-mobile-nav-trigger gmf-mobile-nav-right-trigger"
        ng-click="mainCtrl.toggleRightNavVisibility()">
        <i class="fa fa-wrench"></i>
      </button>
      <div class="overlay" ng-click="mainCtrl.hideNav()"></div>
      <div
        class="gmf-search-overlay"
        ng-click="mainCtrl.hideSearchOverlay()">
      </div>
      <button ngeo-mobile-geolocation=""
        ngeo-mobile-geolocation-map="::mainCtrl.map"
        ngeo-mobile-geolocation-options="::mainCtrl.mobileGeolocationOptions">
        <span class="fa fa-dot-circle-o"></span>
      </button>
      <ngeo-displaywindow
        content="mainCtrl.displaywindowContent"
        desktop="false"
        height="mainCtrl.displaywindowHeight"
        open="mainCtrl.displaywindowOpen"
        title="mainCtrl.displaywindowTitle"
        url="mainCtrl.displaywindowUrl"
        width="mainCtrl.displaywindowWidth"
      ></ngeo-displaywindow>
      <div class="gmf-app-map-messages">
        <gmf-disclaimer gmf-disclaimer-map="::mainCtrl.map"></gmf-disclaimer>
        <div class="alert alert-info alert-dismissible fade in hidden-xs" role="alert">
          <button type="button" class="close" data-dismiss="alert" aria-label="{{'Close' | translate}}"><span aria-hidden="true" class="fa fa-times"></span></button>
          <span translate
            translate-params-url="'${'' if request is None else request.route_url('desktop', _query=no_redirect_query) | n}'">
            You're using the mobile application. Check out the <a href="{{url}}">standard application</a>.</span>
        </div>
      </div>
    </main>
    <nav class="gmf-mobile-nav-left" gmf-mobile-nav>
      <header>
        <a class="gmf-mobile-nav-go-back" href>{{'Back' | translate}}</a>
      </header>
      <!-- main menu -->
      <div class="gmf-mobile-nav-active gmf-mobile-nav-slide">
        <ul>
          <li>
            <a href data-target="#background" data-toggle="slide-in" class="gmf-mobile-nav-button">{{'Background' | translate}}</a>
          </li>
          <li>
            <a href data-target="#themes" data-toggle="slide-in" class="gmf-mobile-nav-button">{{'Themes' | translate}}</a>
          </li>
        </ul>
        <gmf-layertree
          gmf-layertree-dimensions="mainCtrl.dimensions"
          gmf-layertree-map="::mainCtrl.map">
        </gmf-layertree>
      </div>
      <gmf-backgroundlayerselector
        id="background"
        class="gmf-mobile-nav-slide"
        data-header-title="{{'Background' | translate}}"
        gmf-backgroundlayerselector-map="::mainCtrl.map"
        gmf-backgroundlayerselector-select="mainCtrl.hideNav()">
      </gmf-backgroundlayerselector>
      <gmf-themeselector
        id="themes"
        class="gmf-mobile-nav-slide"
        data-header-title="{{'Themes' | translate}}"
        gmf-themeselector-currenttheme="mainCtrl.theme"
        gmf-themeselector-filter="::mainCtrl.filter"
        gmf-mobile-nav-back-on-click>
      </gmf-themeselector>
    </nav>
    <nav class="gmf-mobile-nav-right" gmf-mobile-nav>
      <header>
        <a class="gmf-mobile-nav-go-back" href>{{'Back' | translate}}</a>
      </header>
      <!-- main menu -->
      <div class="gmf-mobile-nav-active gmf-mobile-nav-slide">
        <ul>
          <li>
            <a href data-target="#measure-tools" data-toggle="slide-in" class="gmf-mobile-nav-button">{{'Measure tools' | translate}}</a>
            <a href data-target="#login" data-toggle="slide-in" class="gmf-mobile-nav-button">{{'Login' | translate}}</a>
          </li>
        </ul>
      </div>
      <div id="measure-tools" class="gmf-mobile-nav-slide" data-header-title="{{'Measure tools' | translate}}">
        <ul>
          <li>
            <a ngeo-btn
              ng-click="mainCtrl.hideNav()"
              class="gmf-mobile-nav-button"
              ng-model="mainCtrl.measurePointActive">
              <span class="fa fa-fw" ng-class="{'fa-check': mainCtrl.measurePointActive}"></span>
              {{'Coordinate' | translate}}
            </a>
          </li>
          <li>
            <a ngeo-btn
              ng-click="mainCtrl.hideNav()"
              class="gmf-mobile-nav-button"
              ng-model="mainCtrl.measureLengthActive">
              <span class="fa fa-fw" ng-class="{'fa-check': mainCtrl.measureLengthActive}"></span>
              {{'Length' | translate}}
            </a>
          </li>
        </ul>
      </div>
      <gmf-authentication id="login" class="gmf-mobile-nav-slide" data-header-title="{{'Login' | translate}}"
        gmf-mobile-nav-back="authCtrl.gmfUser.username !== null">
      </gmf-authentication>
    </nav>
    <ngeo-modal
        ng-model="mainCtrl.userMustChangeItsPassword()"
        ng-model-options="{getterSetter: true}">
      <div class="modal-header">
        <h4 class="modal-title">
          {{'You must change your password' | translate}}
        </h4>
      </div>
      <div class="modal-body">
        <gmf-authentication
          gmf-authentication-force-password-change="::true">
        </gmf-authentication>
      </div>
    </ngeo-modal>
    <script src="/${instance}/wsgi/dynamic.js?interface=mobile"></script>
  </body>
</html>
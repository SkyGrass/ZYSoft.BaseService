using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Ufida.T.EAP.AppBase;
using Ufida.T.BAP.Web.Base;
using System.Web.UI.WebControls;
using Chanjet.ZYSoft.BaseService.Interface;
using Ufida.T.EAP.Aop;
using Ufida.T.EAP.DataStruct.Context;
using System.Web;
using Ufida.T.EAP.Dal;
using System.Web.Script.Serialization;

namespace Chanjet.ZYSoft.BaseService.UIP
{
    public class BaseServicePage : IAppHandler
    {
        GenericController controller;
        IBaseService interfaceService;
        Label lbBaseInfo;
        public void AppEventHandler(object sender, AppEventArgs e)
        {
            controller = sender as GenericController;
            lbBaseInfo = controller.GetViewControl("lbBaseInfo") as Label;
            interfaceService = ServiceFactory.getService<IBaseService>();
            Page_Load(sender, e);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            JavaScriptSerializer json = new JavaScriptSerializer();
            UserInfo userInfo = HttpContext.Current.Session["UserInfo"] as UserInfo;
            lbBaseInfo.Text = json.Serialize(userInfo);
        }
    }
}

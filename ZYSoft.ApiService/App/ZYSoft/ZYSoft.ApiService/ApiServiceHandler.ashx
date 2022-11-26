<%@ WebHandler Language="C#" Class="ApiServiceHandler" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.Xml;
using System.Net;
using System.IO;
public class ApiServiceHandler : IHttpHandler
{
    public class Result
    {
        public string state { get; set; }
        public object data { get; set; }
        public string msg { get; set; }
    }

    public void ProcessRequest(HttpContext context)
    {
        ZYSoft.DB.Common.Configuration.ConnectionString = DBMethods.LoadXML("ConnectionString");
        context.Response.ContentType = "text/plain";
        if (context.Request.Form["SelectApi"] != null)
        {
            string result = "";
            switch (context.Request.Form["SelectApi"].ToLower())
            {
                case "getconnect":
                    result = ZYSoft.DB.Common.Configuration.ConnectionString;
                    break;
                default: break;
            }
            context.Response.Write(result);
        }
        else
        {
            context.Response.Write("服务正在运行!");
        }
    }

    public class DBMethods
    {
        public static void AddLogErr(string SPName, string ErrDescribe)
        {
            string tracingFile = Path.Combine(HttpContext.Current.Request.PhysicalApplicationPath, "ZYSoftLog");
            if (!Directory.Exists(tracingFile))
                Directory.CreateDirectory(tracingFile);
            string fileName = DateTime.Now.ToString("yyyyMMdd") + ".txt";
            tracingFile += fileName;
            if (tracingFile != string.Empty)
            {
                FileInfo file = new FileInfo(tracingFile);
                StreamWriter debugWriter = new StreamWriter(file.Open(FileMode.Append, FileAccess.Write, FileShare.ReadWrite));
                debugWriter.WriteLine(SPName + " (" + DateTime.Now.ToString() + ") " + " :");
                debugWriter.WriteLine(ErrDescribe);
                debugWriter.WriteLine();
                debugWriter.Flush();
                debugWriter.Close();
            }
        }

        public static string LoadXML(string key)
        {
            string filename = HttpContext.Current.Request.PhysicalApplicationPath + @"zysoft.service.config";
            XmlDocument xmldoc = new XmlDocument();
            xmldoc.Load(filename);
            XmlNode node = xmldoc.SelectSingleNode("/configuration/appSettings");

            string return_value = string.Empty;
            foreach (XmlElement el in node)//读元素值 
            {
                if (el.Attributes["key"].Value.ToLower().Equals(key.ToLower()))
                {
                    return_value = el.Attributes["value"].Value;
                    break;
                }
            }

            return return_value;
        }
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}
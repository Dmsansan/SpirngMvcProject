package com.sansan.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sansan.dao.Project;
import com.sansan.dao.User;
import com.sansan.service.ProjectService;
import com.sansan.service.UserService;



@Controller
@RequestMapping("/project")
public class ProjectController {
	// 日志记录
    private static final Logger log = Logger.getLogger(Project.class);
    
	@Autowired
	private ProjectService projectServ;
	
	@Autowired
	private UserService userServ;
	
	/**
	 * 跳转项目列表界面
	 * @param request
	 * @return
	 */
	@RequestMapping("/view")
	public ModelAndView View(HttpServletRequest request){
		String contextpath = request.getContextPath();
		Map<String ,Object> model=new HashMap<String,Object>();
		 
		model.put("contextPath",contextpath);
		
		return new ModelAndView("Project/list",model);
	}
	
	/**
	 * 项目添加编辑页面跳转
	 * @param request
	 * @return
	 */
	@RequestMapping("/addAndUpdateView")
	public ModelAndView addAndUpdateView(HttpServletRequest request){
		String contextpath = request.getContextPath();
		Map<String ,Object> model=new HashMap<String,Object>();
		 
		model.put("contextPath",contextpath);
		
		return new ModelAndView("Project/addAndUpdate",model);
	}
	@RequestMapping("/insertProject")
	public @ResponseBody Object insertProject(HttpServletRequest request, Model model){
		try{
			String title = request.getParameter("title");//项目名称
			System.out.print(title+'\n');
//			Integer principalID = 0;
//			if(!StringUtils.isNotEmpty(request.getParameter("principalID"))){
//				principalID = Integer.parseInt(request.getParameter("principalID"));//负责人ID
//			}
			String memberID = request.getParameter("memberID");//项目组成员ID
			String startTime = request.getParameter("startTime");//项目开始时间
			String endTime = request.getParameter("endTime");//项目结束时间
			String description = request.getParameter("description");//项目描述
			Integer status = 0;
			if(!StringUtils.isNotEmpty(title)){
				model.addAttribute("code", 100);
				model.addAttribute("msg", "缺少必填参数！");
				return model;
			}else{
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("title", title);
				
				//map.put("principalID", principalID);
				map.put("memberID", memberID);
				map.put("startTime", startTime);
				map.put("endTime", endTime);
				map.put("description", description);
				map.put("status", status);
				model.addAttribute("msg",title);
				return model;
			}
		}catch(Exception e){
			model.addAttribute("code", 101);
			model.addAttribute("msg", "服务器异常！");
			return model;
		}
		
	}
	/**
	 * 获取项目列表数据
	 * @param req
	 * @param model
	 * @return
	 */
	@RequestMapping("/list")
	public @ResponseBody Object projectList(HttpServletRequest request, Model model){
		try{
			Integer page = request.getParameter("page")==null? 1:Integer.parseInt(request.getParameter("page"));//当前页
			Integer pageNum = request.getParameter("pageNum")==null ? 10:Integer.parseInt(request.getParameter("pageNum"));//每页数量
			Integer start = pageNum*(page-1);
			Integer end = pageNum*page;
			
			Map<String,Integer> map = new HashMap<String,Integer>();
			map.put("start",start);
			map.put("end", end);
			//返回集合，集合里面的类需要定义
			List<Project> list = projectServ.getProjectList(map);
			
			//获取总的记录条数
			int total = projectServ.getProjectNumbers();
			
			String memberID="";
			String arr[]=new String[100];
			String memberName = "";
			String member = "";
			for(Project proList:list){
				System.out.print(proList.getMemberid());
				memberID = proList.getMemberid();
				//字符串分割为数组函数split
	            arr = memberID.split(",");
				for(int i=0;i<arr.length;i++){
				//获取用户姓名
				List<User>  user = userServ.getUserInfo(Integer.parseInt(arr[i]));
					for(User UserList:user){
						if(i == arr.length-1){
							memberName=UserList.getName();
						}else{
							memberName=UserList.getName()+",";
						}
					}
					member += memberName;
				}
				proList.setMembername(member);
				proList.setTotal(total);
				proList.setPage(page);
				System.out.print(member);
				member = "";
				
			}
			model.addAttribute("code", 100);
			model.addAttribute("data", list);
		}catch(Exception e){
			log.info(e);
			model.addAttribute("code", 101);
			model.addAttribute("msg", "异常！");
		}
		return model;
	}
}

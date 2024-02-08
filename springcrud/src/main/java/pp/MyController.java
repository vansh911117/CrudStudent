package pp;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.query.criteria.internal.expression.function.AggregationFunction.COUNT;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@Controller
public class MyController {
	@Autowired
	private Edao edao;

	@RequestMapping("/searchController")
	public String searchController(@RequestParam int charCount,@RequestParam String inputText,Model m) {
		System.out.println(charCount);
		List<Emp> emp =	edao.search(inputText);
		m.addAttribute("employees", emp);
		return "employeeData";
	}

	@RequestMapping("hello")
	public String home() {
		return "hello";
	}

	@PostMapping("/submitData")
	public @ResponseBody String submitData(@RequestBody List<Emp> employeeList) {
		Gson gson = new Gson();
		String jsonData = gson.toJson(employeeList);
		edao.saveEmployees(employeeList);
		return "success";
	}

	@RequestMapping(value = "/getEmployeeData", method = RequestMethod.GET)
	public String getEmployeeData(Model model, @RequestParam(defaultValue = "0", required = false) int index,
			@RequestParam(defaultValue = "false", required = false) boolean isLast,@RequestParam(defaultValue = "", required = false)  String inputText,@RequestParam(defaultValue = "null", required = false) String selectedOption) {
		// Fetch all employee data from the database
		
		int pagesize = 5;
		int count = edao.getTotalCount(inputText,selectedOption);
		System.out.println("count>>>>>"+count);
		int last = count / pagesize;
		if (index < last) {
			if (index <= 0) {
				index = 0;
			} else {
				index = index;
			}
		} else {
			index = last;
		}
		if (isLast) {
			System.out.println(count);
			
			index = last;
		}

		List<Emp> employeeList = edao.getAllEmployees(index,inputText,selectedOption);
		if (employeeList != null && employeeList.size() > 0) {
			model.addAttribute("employeessize", employeeList.size());
		}

		// Add employeeList to the model
		model.addAttribute("employees", employeeList);
		model.addAttribute("index", index);
		model.addAttribute("isLast", isLast);
		model.addAttribute("inputText", inputText);
		model.addAttribute("selectedOption", selectedOption);

		// Return the name of the JSP file to render
		return "employeeData";
	}

	/*
	 * @RequestMapping("/update") public String updateData(Emp e,Model m) {
	 * edao.updateEmp(e); List<Emp> al=edao.show(); m.addAttribute("data", al);
	 * return "view"; }
	 *//*
		 * @RequestMapping("/show") public String showData(Model m) { List<Emp>
		 * al=edao.show(); m.addAttribute("data", al); return "view"; }
		 */
	/*
	 * @RequestMapping("/deletepro") public String deleteData(@RequestParam("id")
	 * int id,Model m) { edao.deleteEmp(id); List<Emp> al=edao.show();
	 * m.addAttribute("data", al); return "view"; }
	 */
	@PostMapping(value = "/editemp")
	public String editemp(@RequestBody Emp emp) {
		System.out.println("inside controller" + emp.getAddress());
		edao.updateEmp(emp);
		return "employeeData";
	}

}

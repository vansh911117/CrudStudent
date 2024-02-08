<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page isELIgnored="false"%>
<div style="margin: 20px;",>
	<h2>Employee Data</h2>
	<table border="1">
		<thead>
			<tr>
				<th>ID</th>
				<th>Name</th>
				<th>Salary</th>
				<th>address</th>
				<th>age</th>
				<th>dob</th>
				<th>phone</th>
				<th>action</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="employee" items="${employees}" end="4">
				<tr>
					<td>${employee.id}</td>
					<td>${employee.name}</td>
					<td>${employee.salary}</td>
					<td>${employee.address}</td>
					<td>${employee.age}</td>
					<td>${employee.dob}</td>
					<td>${employee.phone}</td>
					<td><button onclick="editemp(${employee.id})">Edit</button></td>
				</tr>

				<tr id="newRow${employee.id}" class="newRow" style="display: none;">
					<td><input size=1 type="text" value="${employee.id}"
						id="id${employee.id}" readOnly /></td>
					<td><input size=1 type="text" value="${employee.name}"
						id="name${employee.id}" /></td>
					<td><input size=1 type="number" value="${employee.salary}"
						id="salary${employee.id}" /></td>
					<td><input size=1 type="text" value="${employee.address}"
						id="address${employee.id}" /></td>
					<td><input size=1 type="text" value="${employee.age}"
						id="age${employee.id}" /></td>
					<td><input size=1 type="Date" value="${employee.dob}"
						id="dob${employee.id}" /></td>
					<td><input size=1 type="number" value="${employee.phone}"
						id="phone${employee.id}" /></td>
					<td><input type="button" onclick="update(${employee.id})"
						value="Update"> <%-- <input type="submit"
						onclick="deleteemp(${employee.id})" value="delete"></td> --%>
				</tr>


			</c:forEach>
		</tbody>
	</table>
	<c:if test="${index > 0}">
		<button onclick="firstPage()">First</button>
		<button onclick="PrePage()">Previous</button>
	</c:if>
	<input type="text" id="show" value="${index+1}" style="width: 30px;">
	<button onclick="show()">show</button>

	<c:if test="${employeessize >5}">
		<button onclick="nextPage()">next</button>
		<button onclick="lastPage()">last</button>
	</c:if>

</div>
<input type="hidden" id="index" value="${index} ">

<input type="hidden" id="last" value="${isLast}">
<input type="hidden" id="id" value="${id}">
<input type="hidden" id="inputText" value="${inputText}">
<input type="hidden" id="selectedOption" value="${selectedOption}">
<script>

function editemp(id) {
    // Hide all elements with class 'newRow'
    console.log("edit emp")
     $(".newRow").hide(); 

    // Show the specific element with ID 'newRow' + email
    $("#newRow" + $.escapeSelector(id)).show();
}

function update(id)
{
	debugger;
	var data= {
	 id:$("#id"+id).val(),
	 name:$("#name"+id).val(),
	 salary:$("#salary"+id).val(),
	 address:$("#address"+id).val(),
	 age:$("#age"+id).val(),
	 dob:$("#dob"+id).val(),
	 phone:$("#phone"+id).val(),
	}
	
	 $.ajax({
         url: '/Springmvc/editemp',
         type: 'POST',
         contentType:"application/json",
         data: JSON.stringify(data), 
         success : function(response) 
         {
 			$('.newRow').hide();
 			fetchEmployeeData();
 		},
 		error : function(error) {
 			console.error('Error:', error);
 		}
});
}

function show()
{
	
	
	var value=$("#show").val();
	value=parseInt(value);
	var index = $("#index").val();
	index=parseInt(index);
	index=value-1;
	var inputText = $("#inputText").val();
	var selectedOption = $("#selectedOption").val();
	
	

	$.ajax({
		type : 'GET',
		url : '/Springmvc/getEmployeeData',
		data: {
			index:index,
			inputText:inputText,
			selectedOption:selectedOption
		},
			
	
		success : function(response) {
			// Display updated employee data
			$('#employeeData').html(response);
		},
		error : function(error) {
			console.error('Error:', error);
		}
	});
	
	}




	function nextPage() {
		debugger;
		var index = $("#index").val();
		index = parseInt(index);
		var inputText = $("#inputText").val();
		var selectedOption = $("#selectedOption").val();
		/* var charCount = inputText.length;
		charCount=parseInt(charCount); */
		index++;
		
		$.ajax({
			type : 'GET',
			url : '/Springmvc/getEmployeeData',
			data:
					{
						index:index,
						inputText:inputText,
						selectedOption:selectedOption
					},
			success : function(response) {
				// Display updated employee data
				$('#employeeData').html(response);
			},
			error : function(error) {
				console.error('Error:', error);
			}
		});

	}
	
	function lastPage()
	{
		var index = $("#index").val();
		var isLast = true;
		var inputText = $("#inputText").val();
		var selectedOption = $("#selectedOption").val();
		
		$.ajax({
			type : 'GET',
			url : '/Springmvc/getEmployeeData',
			data:{
				
				index:index,
				isLast:isLast,
				inputText:inputText,
				selectedOption:selectedOption
			},
				
		
			success : function(response) {
				// Display updated employee data
				$('#employeeData').html(response);
			},
			error : function(error) {
				console.error('Error:', error);
			}
		});

		
	}
	
	
	
	function PrePage()
	{
		var index = $("#index").val();
		index = index -1;
		var inputText = $("#inputText").val();
		var selectedOption = $("#selectedOption").val();
		
		$.ajax({
			type : 'GET',
			url : '/Springmvc/getEmployeeData',
			data:
				{
				index:index,
				inputText:inputText,
				selectedOption:selectedOption
				},
		
			success : function(response) {
				// Display updated employee data
				$('#employeeData').html(response);
			},
			error : function(error) {
				console.error('Error:', error);
			}
		});
	}
	
	function firstPage()
	{
		var index = $("#index").val();
		index=0;
		var inputText = $("#inputText").val();
		var selectedOption = $("#selectedOption").val();
		
		$.ajax({
			type : 'GET',
			url : '/Springmvc/getEmployeeData',
			data:
                  {
				index:index,
				inputText:inputText,
				selectedOption:selectedOption
				
				},
			success : function(response) {
				// Display updated employee data
				$('#employeeData').html(response);
			},
			error : function(error) {
				console.error('Error:', error);
			}
		});
	}
	
	
	/* function editemp(){
		 let row = button.parentNode.parentNode;
		    let cells = row.getElementsByTagName("td");

		    // Create an editable row
		    let editRow = document.createElement("tr");
		    for (let i = 0; i < cells.length - 1; i++) {
		      let cell = document.createElement("td");
		      let input = document.createElement("input");
		      input.type = "text";
		      input.value = cells[i].innerText;
		      cell.appendChild(input);
		      editRow.appendChild(cell);
		
		
	} */
	
	
	
</script>
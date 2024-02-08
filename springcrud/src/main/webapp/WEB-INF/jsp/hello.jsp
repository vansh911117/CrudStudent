<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Employee Data Entry</title>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
</head>
<body>
	<button type="button" onclick="showForm()">Add Emp</button>
	<br>
	<input type="text" id="search">&nbsp; 
	
	
	 <label for="dropdown">Choose an option:</label>
  <select id="dropdown" onchange="dropdown()">
  	<option value="age">age</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24">24</option>
    <!-- Add more options as needed -->
  </select>
  
  
	<div id="addEmployeeDiv" style="display: none;">
		<h2>Employee Data Entry</h2>

		<div class="fieldSet">
			<label for="id">ID:</label> <input id="id" type="text" name="id"
				required> <label for="name">Name:</label> <input id="name"
				type="text" name="name" required> <label for="salary">Salary:</label>
			<input id="sal" type="text" name="sal" required> <label
				for="address">Address</label> <input id="address" type="text"
				name="address" required><label for="age">Age</label> <input
				id="age" type="text" name="age" required><label for="dob">Dob</label>
			<input id="dob" type="Date" name="dob" required><label
				for="phone">Mobile Number</label> <input id="phone" type="text"
				name="phone" required>
			<button type="button" onclick="cloneFields()">+</button>
		</div>
		<div id="fieldsContainer"></div>
		<button type="button" onclick="submitForm()">Submit</button>
	</div>




	<!-- Display existing and submitted data -->
	<div id="employeeData">

		<jsp:include page="employeeData.jsp"></jsp:include>
	</div>

	<script>
	
	function dropdown()
	{
		
		var selectedOption = document.getElementById("dropdown").value;
		var inputText=$("#search").val();
		console.log(selectedOption);
		
		$.ajax({
			url : "/Springmvc/getEmployeeData",
			method : "GET",
			data : {
				selectedOption:selectedOption,
				inputText:inputText
			},
			success : function(response) {
				$("#employeeData").html(response);
				
			},
			error : function(xhr, status, error) {
				console.log("Error:", error);
			}
		});
		
		
		
		
		
	}
	
	
	
	
	
	
		$(document).ready(function() {
			$('#search').on('input', function() {
				var inputText = $(this).val();
				var charCount = inputText.length;
				charCount=parseInt(charCount);
				var selectedOption = document.getElementById("dropdown").value;
				console.log(charCount);
				if(charCount > 2) {
					$.ajax({
						url : "/Springmvc/getEmployeeData",
						method : "GET",
						data : {
							charCount : charCount,
							inputText:inputText,
							selectedOption:selectedOption
						},
						success : function(response) {
							$("#employeeData").html(response);
							
						},
						error : function(xhr, status, error) {
							console.log("Error:", error);
						}
					});
				}
				else
					{
					
					fetchEmployeeData();
					
					}
				
			});
		});

		function showForm() {
			$("#addEmployeeDiv").show();
		}
		/* // Fetch initial employee data when the page loads */

		$(document).ready(function() {
			fetchEmployeeData();
		});

		function cloneFields() {
			var originalFieldSet = $('.fieldSet:first');
			var clonedFieldSet = originalFieldSet.clone();

			// Clear values in the cloned fields
			clonedFieldSet.find('input').val('');

			// Append the cloned fields to the container
			$('#fieldsContainer').append(clonedFieldSet);

			clonedFieldSet.find('button').text('-').attr('onclick',
					'removeFields(this)');
		}
		function removeFields(button) {
			// Remove the parent fieldSet when the "-" button is clicked
			$(button).parent().remove();
		}

		function clearAllValues() {
			$("#fieldsContainer").html('');
			$("#id").val('');
			$("#name").val('');
			$("#salary").val('');
		}
		function submitForm() {
			// Array to store form data
			var formDataArray = [];

			// Push values of the three fields (id, name, salary) into the array
			$('.fieldSet').each(function() {
				var id = $(this).find('input[name="id"]').val();
				var name = $(this).find('input[name="name"]').val();
				var salary = $(this).find('input[name="sal"]').val();
				var address = $(this).find('input[name="address"]').val();
				var age = $(this).find('input[name="age"]').val();
				var dob = $(this).find('input[name="dob"]').val();
				var phone = $(this).find('input[name="phone"]').val();

				formDataArray.push({
					id : id,
					name : name,
					salary : salary,
					address : address,
					age : age,
					dob : dob,
					phone : phone
				});
			});

			// Log the array (you can send it to the server or perform other actions)
			console.log(formDataArray);

			// Now you can send formDataArray to the server using AJAX or include it in a hidden input field in the form
			// Example using AJAX (replace with your actual endpoint and logic)
			$.ajax({
				type : 'POST',
				url : '/Springmvc/submitData',
				contentType : 'application/json',
				data : JSON.stringify(formDataArray),
				success : function(response) {
					if (response == "success") {
						fetchEmployeeData();
						$("#addEmployeeDiv").hide();
						console.log(response);
						clearAllValues();
					}
					// Handle the server response as needed
				},
				error : function(error) {
					console.error('Error submitting data:', error);
				}
			});
		}

		function fetchEmployeeData() {
			// Fetch employee data from the server with AJAX
			$.ajax({
				type : 'GET',
				url : '/Springmvc/getEmployeeData',
				success : function(response) {
					// Display updated employee data
					$('#employeeData').html(response);
				},
				error : function(error) {
					console.error('Error:', error);
				}
			});
		}
	</script>
</body>
</html>

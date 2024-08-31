create table doctor(
	Doctor_id int not null,
	Doctor_name varchar(20),
	Specialization varchar(25),
	DoctorContact varchar(20)
);

ALTER TABLE doctor
ALTER COLUMN Specialization 
TYPE VARCHAR(40);

copy doctor(Doctor_id,Doctor_name,Specialization,DoctorContact)
from 'G:\DATA ANALYTICS\sql project\New folder\New folder\Doctor.csv' delimiter ',' csv header;

select * from doctor



create table Medical_procedure(
	Procedure_id int not null,
	Procedure_name varchar(50),
	appoinment_id int not null
)


copy Medical_procedure(Procedure_id,Procedure_name,appoinment_id)
from 'G:\DATA ANALYTICS\sql project\New folder\New folder\Medical Procedure.csv'
delimiter ',' csv header

select * from Medical_procedure

create table Patient(
	Patient_id int not null,
	first_name varchar(20),
	last_name varchar(20),
	email varchar(30)
)
copy Patient(Patient_id,first_name,last_name,email)
from 'G:\DATA ANALYTICS\sql project\New folder\New folder\Patient.csv'
delimiter ',' csv header

alter table Patient
alter column email
type varchar(40)
select * from Patient


/* doctors and specialization*/
select Doctor_name,Specialization from doctor;

/*Find all appointments for the doctor with DoctorID 116*/


select * from appointment
select * from doctor
select * from Patient
select * from Medical_procedure

select appointment_id,doctor_id  from appointment where doctor_id=116

/*List all procedure names from the procedures table.*/
select Procedure_name from Medical_procedure;

/*Get the email addresses of all patients from the patients table.*/
select email from Patient;

/*Join the patients and appointments tables to get patient details for each appointment.*/
select * from appointment
select * from doctor
select * from Patient
select * from Medical_procedure
select * from billing

select * from Patient p join appointment a 
on p.patient_id = a.patient_id

/*Count the number of appointments each doctor has.*/
select  doctor_name,count(appointment_id) from appointment a join doctor d 
on a.doctor_id=d.doctor_id 
group by doctor_name

/*Find all invoices for the patient with PatientID 894.*/
select invoice_id from billing where patient_id =894

/*List all doctors who specialize in "Infectious disease".*/

select doctor_name,Specialization  from doctor d join appointment a
on d.doctor_id=a.doctor_id where Specialization='Infectious disease' 
group by doctor_name,Specialization


/*Get the details of the appointment with AppointmentID 701*/
select * from appointment where appointment_id=701

/*Find the total amount of all invoices.*/

select invoice_id,sum(amount) as amount from billing 
group by invoice_id

alter table doctor 
alter column doctorcontact
type varchar(60)
update doctor
set doctorcontact=concat(doctor_name,doctorcontact)
select * from doctor

/*Get the DoctorName and DoctorContact for all doctors.*/
select doctor_name,doctorcontact from doctor;


/*Find the doctor who has the most appointments.*/
select count(appointment_id) as appointments,doctor_name from doctor d join appointment a 
on d.doctor_id=a.doctor_id
group by doctor_name order by count(appointment_id) desc limit 1



/*List all patients who have an appointment on 08-04-2022.*/
select  concat(p.first_name,' ',p.last_name)as patients from Patient p
join appointment a on p.patient_id=a.patient_id 
where a.date='08-04-2022'


/*Get the details of patients who have undergone a "Kidney transplant" procedure.*/
select p.patient_id,concat(p.first_name,' ',p.last_name) as patien_name,procedure_name from Patient p join appointment a
on p.patient_id=a.patient_id join Medical_procedure m
on m.appoinment_id=a.appointment_id
where procedure_name='Kidney transplant'

/*Calculate the total amount of invoices for each patient.*/
select * from billing

select count(b.invoice_id) as invoices,concat(p.first_name,' ',p.last_name) as patient_names
from billing b join Patient p 
on b.patient_id = p.patient_id
group by patient_names

select count(patient_id) from Patient

/*Find all procedures that have not been assigned to any appointments.*/
/*select pr.procedure_name from Medical_procedure pr  join
appointment a on pr.appoinment_id =a.appointment_id
where a.appointment_id is null
*/
select * from Medical_procedure
select * from doctor
SELECT distinct pr.procedure_name
FROM Medical_procedure pr
LEFT JOIN appointment a ON pr.appoinment_id  = a.appointment_id
WHERE a.appointment_id IS NULL;

select * from appointment where appointment_id=955;
select * from Medical_procedure where appoinment_id=955

/*Get the list of doctors along with the number of procedures they have performed.*/
select d.doctor_name,count(pr.procedure_name) from doctor d
join appointment a on d.doctor_id=a.doctor_id 
join Medical_procedure pr on  pr.appoinment_id=a.appointment_id
group by d.doctor_name



/*Find the most recent appointment for each patient and display their name and appointment details.*/
select * from 
(select a.*,
rank() over(partition by patient_id order by date desc ) as rnk
from appointment a)b
where b.rnk=1


/*List doctors along with the number of procedures they have performed, and rank them based on the number of procedures.*/
	
select * ,
rank() over(order by numbers desc) as rnk from(
select d.doctor_name,count(procedure_id) as numbers from doctor d join appointment a 
on d.doctor_id=a.doctor_id join Medical_procedure m
on m.appoinment_id=a.appointment_id
group by doctor_name) a 


SELECT doctor_name, 
       numbers AS number_of_procedures, 
       RANK() OVER (ORDER BY numbers DESC) AS rnk
FROM (
    SELECT d.doctor_name, COUNT(m.procedure_id) AS numbers
    FROM doctor d 
    JOIN appointment a ON d.doctor_id = a.doctor_id 
    JOIN Medical_procedure m ON m.appoinment_id = a.appointment_id
    GROUP BY d.doctor_name
) subquery;




-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://github.com/pgadmin-org/pgadmin4/issues/new/choose if you find any bugs, including reproduction steps.
BEGIN;

CREATE SEQUENCE IF NOT EXISTS "Account_id_seq";
CREATE SEQUENCE IF NOT EXISTS "MedicalInventory_id_seq";
CREATE SEQUENCE IF NOT EXISTS "MedicalRecord_id_seq";
CREATE SEQUENCE IF NOT EXISTS "Payment_id_seq";
CREATE SEQUENCE IF NOT EXISTS "Position_id_seq";
CREATE SEQUENCE IF NOT EXISTS "Prescription_id_seq";
CREATE SEQUENCE IF NOT EXISTS "PrescriptionDetail_id_seq";
CREATE SEQUENCE IF NOT EXISTS "Profile_id_seq";
CREATE SEQUENCE IF NOT EXISTS "Scheduling_id_seq";
CREATE SEQUENCE IF NOT EXISTS "Service_id_seq";
CREATE SEQUENCE IF NOT EXISTS "ServiceNote_id_seq";
CREATE SEQUENCE IF NOT EXISTS "Staff_id_seq";

CREATE TYPE public."InventoryType" AS ENUM
    ('medicine', 'aid', 'other');
	
CREATE TYPE public."PaymentStatus" AS ENUM
    ('pending', 'paid', 'cancelled');

CREATE TYPE public."ProfileType" AS ENUM
    ('staff', 'patient');

CREATE TYPE public."Role" AS ENUM
    ('patient', 'medics', 'officer', 'owner');

CREATE TYPE public."SchedulingStatus" AS ENUM
    ('scheduled', 'completed', 'cancelled');

CREATE TYPE public."Session" AS ENUM
    ('morning', 'afternoon', 'evening');

CREATE TABLE IF NOT EXISTS public."Account"
(
    id integer NOT NULL DEFAULT nextval('"Account_id_seq"'::regclass),
    username character varying(50) COLLATE pg_catalog."default" NOT NULL,
    email character varying(100) COLLATE pg_catalog."default" NOT NULL,
    password character varying(255) COLLATE pg_catalog."default" NOT NULL,
    role "Role" NOT NULL,
    created_at timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(3) without time zone,
    profile_id integer NOT NULL,
    CONSTRAINT "Account_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public."MedicalInventory"
(
    id integer NOT NULL DEFAULT nextval('"MedicalInventory_id_seq"'::regclass),
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    price numeric(12, 2) NOT NULL,
    stock integer NOT NULL,
    type "InventoryType" NOT NULL,
    created_at timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(3) without time zone,
    CONSTRAINT "MedicalInventory_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public."MedicalRecord"
(
    id integer NOT NULL DEFAULT nextval('"MedicalRecord_id_seq"'::regclass),
    scheduling_id integer NOT NULL,
    patient_id integer NOT NULL,
    complaint text COLLATE pg_catalog."default",
    medical_history text COLLATE pg_catalog."default",
    physical_examination text COLLATE pg_catalog."default",
    systolic integer,
    diastolic integer,
    heart_rate integer,
    respiratory_rate integer,
    temperature numeric(5, 2),
    created_at timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(3) without time zone,
    CONSTRAINT "MedicalRecord_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public."Payment"
(
    id integer NOT NULL DEFAULT nextval('"Payment_id_seq"'::regclass),
    service_note_id integer NOT NULL,
    amount numeric(12, 2) NOT NULL,
    status "PaymentStatus" NOT NULL,
    payment_method character varying(50) COLLATE pg_catalog."default",
    created_at timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(3) without time zone,
    CONSTRAINT "Payment_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public."Position"
(
    id integer NOT NULL DEFAULT nextval('"Position_id_seq"'::regclass),
    name text COLLATE pg_catalog."default" NOT NULL,
    max_salary integer NOT NULL,
    min_salary integer NOT NULL,
    CONSTRAINT "Position_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public."Prescription"
(
    id integer NOT NULL DEFAULT nextval('"Prescription_id_seq"'::regclass),
    service_note_id integer NOT NULL,
    created_at timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(3) without time zone,
    CONSTRAINT "Prescription_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public."PrescriptionDetail"
(
    id integer NOT NULL DEFAULT nextval('"PrescriptionDetail_id_seq"'::regclass),
    prescription_id integer NOT NULL,
    medical_inventory_id integer NOT NULL,
    quantity integer NOT NULL,
    dosage_instructions text COLLATE pg_catalog."default",
    created_at timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(3) without time zone,
    CONSTRAINT "PrescriptionDetail_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public."Profile"
(
    id integer NOT NULL DEFAULT nextval('"Profile_id_seq"'::regclass),
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    dob date,
    gender character varying(10) COLLATE pg_catalog."default",
    address text COLLATE pg_catalog."default",
    phone character varying(50) COLLATE pg_catalog."default",
    type "ProfileType" NOT NULL,
    created_at timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(3) without time zone,
    age integer,
    CONSTRAINT "Profile_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public."Scheduling"
(
    id integer NOT NULL DEFAULT nextval('"Scheduling_id_seq"'::regclass),
    staff_id integer NOT NULL,
    patient_id integer NOT NULL,
    service_id integer NOT NULL,
    date date NOT NULL,
    session "Session" NOT NULL,
    status "SchedulingStatus" NOT NULL,
    created_at timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(3) without time zone,
    CONSTRAINT "Scheduling_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public."Service"
(
    id integer NOT NULL DEFAULT nextval('"Service_id_seq"'::regclass),
    name text COLLATE pg_catalog."default" NOT NULL,
    price integer NOT NULL,
    CONSTRAINT "Service_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public."ServiceNote"
(
    id integer NOT NULL DEFAULT nextval('"ServiceNote_id_seq"'::regclass),
    scheduling_id integer NOT NULL,
    medical_record_id integer NOT NULL,
    additional_notes text COLLATE pg_catalog."default",
    created_at timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(3) without time zone,
    CONSTRAINT "ServiceNote_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public."Staff"
(
    id integer NOT NULL DEFAULT nextval('"Staff_id_seq"'::regclass),
    created_at timestamp(3) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(3) without time zone,
    active boolean NOT NULL DEFAULT true,
    join_date date NOT NULL,
    position_id integer NOT NULL,
    profile_id integer NOT NULL,
    CONSTRAINT "Staff_pkey" PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public."StaffService"
(
    staff_id integer NOT NULL,
    service_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    CONSTRAINT "StaffService_pkey" PRIMARY KEY (staff_id, service_id, start_date)
);


-- Create indexes for all foreign key relationships
CREATE INDEX IF NOT EXISTS "idx_account_profile" ON public."Account"(profile_id);
CREATE INDEX IF NOT EXISTS "idx_medical_record_scheduling" ON public."MedicalRecord"(scheduling_id);
CREATE INDEX IF NOT EXISTS "idx_medical_record_patient" ON public."MedicalRecord"(patient_id);
CREATE INDEX IF NOT EXISTS "idx_payment_service_note" ON public."Payment"(service_note_id);
CREATE INDEX IF NOT EXISTS "idx_prescription_service_note" ON public."Prescription"(service_note_id);
CREATE INDEX IF NOT EXISTS "idx_prescription_detail_prescription" ON public."PrescriptionDetail"(prescription_id);
CREATE INDEX IF NOT EXISTS "idx_prescription_detail_inventory" ON public."PrescriptionDetail"(medical_inventory_id);
CREATE INDEX IF NOT EXISTS "idx_scheduling_staff" ON public."Scheduling"(staff_id);
CREATE INDEX IF NOT EXISTS "idx_scheduling_patient" ON public."Scheduling"(patient_id);
CREATE INDEX IF NOT EXISTS "idx_scheduling_service" ON public."Scheduling"(service_id);
CREATE INDEX IF NOT EXISTS "idx_service_note_scheduling" ON public."ServiceNote"(scheduling_id);
CREATE INDEX IF NOT EXISTS "idx_service_note_medical_record" ON public."ServiceNote"(medical_record_id);
CREATE INDEX IF NOT EXISTS "idx_staff_position" ON public."Staff"(position_id);
CREATE INDEX IF NOT EXISTS "idx_staff_profile" ON public."Staff"(profile_id);
CREATE INDEX IF NOT EXISTS "idx_staff_service_staff" ON public."StaffService"(staff_id);
CREATE INDEX IF NOT EXISTS "idx_staff_service_service" ON public."StaffService"(service_id);

ALTER TABLE IF EXISTS public."Account"
    ADD CONSTRAINT "Account_profile_id_fkey" FOREIGN KEY (profile_id)
    REFERENCES public."Profile" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."MedicalRecord"
    ADD CONSTRAINT "MedicalRecord_patient_id_fkey" FOREIGN KEY (patient_id)
    REFERENCES public."Profile" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."MedicalRecord"
    ADD CONSTRAINT "MedicalRecord_scheduling_id_fkey" FOREIGN KEY (scheduling_id)
    REFERENCES public."Scheduling" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."Payment"
    ADD CONSTRAINT "Payment_service_note_id_fkey" FOREIGN KEY (service_note_id)
    REFERENCES public."ServiceNote" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."Prescription"
    ADD CONSTRAINT "Prescription_service_note_id_fkey" FOREIGN KEY (service_note_id)
    REFERENCES public."ServiceNote" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."PrescriptionDetail"
    ADD CONSTRAINT "PrescriptionDetail_medical_inventory_id_fkey" FOREIGN KEY (medical_inventory_id)
    REFERENCES public."MedicalInventory" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."PrescriptionDetail"
    ADD CONSTRAINT "PrescriptionDetail_prescription_id_fkey" FOREIGN KEY (prescription_id)
    REFERENCES public."Prescription" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."Scheduling"
    ADD CONSTRAINT "Scheduling_patient_id_fkey" FOREIGN KEY (patient_id)
    REFERENCES public."Profile" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."Scheduling"
    ADD CONSTRAINT "Scheduling_service_id_fkey" FOREIGN KEY (service_id)
    REFERENCES public."Service" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."Scheduling"
    ADD CONSTRAINT "Scheduling_staff_id_fkey" FOREIGN KEY (staff_id)
    REFERENCES public."Staff" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."ServiceNote"
    ADD CONSTRAINT "ServiceNote_medical_record_id_fkey" FOREIGN KEY (medical_record_id)
    REFERENCES public."MedicalRecord" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."ServiceNote"
    ADD CONSTRAINT "ServiceNote_scheduling_id_fkey" FOREIGN KEY (scheduling_id)
    REFERENCES public."Scheduling" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."Staff"
    ADD CONSTRAINT "Staff_position_id_fkey" FOREIGN KEY (position_id)
    REFERENCES public."Position" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."Staff"
    ADD CONSTRAINT "Staff_profile_id_fkey" FOREIGN KEY (profile_id)
    REFERENCES public."Profile" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."StaffService"
    ADD CONSTRAINT "StaffService_service_id_fkey" FOREIGN KEY (service_id)
    REFERENCES public."Service" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public."StaffService"
    ADD CONSTRAINT "StaffService_staff_id_fkey" FOREIGN KEY (staff_id)
    REFERENCES public."Staff" (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

END;
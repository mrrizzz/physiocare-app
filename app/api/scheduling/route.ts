import db from "@/lib/db";
import { handleError } from "@/utils/error-handling";
import { getTokenFromRequest } from "@/utils/jwt-decode";
import { SchedulingStatus } from "@prisma/client";
import { NextRequest, NextResponse } from "next/server";

export async function POST(req: NextRequest) {
  console.log("POST SCHEDULEEEEE\n", req);
  try {
    // console.log(req);
    const tokenInfo = getTokenFromRequest(req);
    const body = await req.json();

    const { staff_id, service_id, date, session } = body;

    const newSchedule = await db.scheduling.create({
      data: {
        staff_id: parseInt(staff_id),
        patient_id: tokenInfo.id,
        service_id: parseInt(service_id),
        date: new Date(date),
        session,
        status: "scheduled" as SchedulingStatus,
      },
    });

    return NextResponse.json({
      success: true,
      message: "Scheduling created successfully",
      data: newSchedule,
    });
  } catch (error) {
    return handleError(error);
  }
}

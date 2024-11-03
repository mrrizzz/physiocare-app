import { NextRequest, NextResponse } from "next/server";
import { getTokenFromRequest } from "@/utils/jwt-decode";
import { handleError } from "@/utils/error-handling";
import db from "@/lib/db";

export async function GET(req: NextRequest) {
  try {
    const tokenInfo = getTokenFromRequest(req);
    if ("statusCode" in tokenInfo) {
      return NextResponse.json(
        { success: false, message: tokenInfo.message },
        { status: tokenInfo.statusCode }
      );
    }

    const userId = tokenInfo.id;

    const [upcomingAppointments, recentMedicalRecords] = await Promise.all([
      db.scheduling.findMany({
        where: {
          patient_id: userId,
          date: { gte: new Date() },
          status: "SCHEDULED",
        },
        orderBy: { date: "asc" },
        take: 5,
      }),
      db.medicalRecord.findMany({
        where: { patient_id: userId },
        orderBy: { created_at: "desc" },
        take: 5,
      }),
    ]);

    const dashboardData = {
      upcomingAppointments: {
        count: upcomingAppointments.length,
        next: upcomingAppointments[0],
      },
      recentMedicalRecords: {
        count: recentMedicalRecords.length,
        lastUpdated: recentMedicalRecords[0]?.created_at,
      },
    };

    return NextResponse.json({
      success: true,
      data: dashboardData,
    });
  } catch (error) {
    return handleError(error);
  }
}

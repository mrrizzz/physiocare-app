// Di API route (app/api/staff/route.ts atau pages/api/staff.ts)
import db from "@/lib/db";
import { NextResponse } from "next/server";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const serviceId = searchParams.get("id");

  try {
    const staffMembers = await db.staffService.findMany({
      where: {
        service_id: Number(serviceId),
        // Hanya ambil staff yang masih aktif dan belum end_date
        end_date: null,
        staff: {
          active: true,
        },
      },
      select: {
        staff: {
          select: {
            id: true,
            profile: {
              select: {
                name: true,
                // Bisa tambahkan field profile lain yang dibutuhkan
              },
            },
            position: {
              select: {
                name: true,
              },
            },
          },
        },
        start_date: true,
      },
    });

    // Transform data untuk response yang lebih bersih
    const formattedStaff = staffMembers.map((staffService) => ({
      id: staffService.staff.id,
      name: staffService.staff.profile.name,
      position: staffService.staff.position.name,
      startDate: staffService.start_date,
    }));

    return NextResponse.json({
      data: formattedStaff,
    });
  } catch (error) {
    console.error("Database error:", error);
    return NextResponse.json(
      { error: "Failed to fetch staff members" },
      { status: 500 }
    );
  }
}

// Tipe untuk response data
type StaffResponse = {
  id: number;
  name: string;
  position: string;
  startDate: Date;
}[];

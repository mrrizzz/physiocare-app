import db from "@/lib/db";
import { UpdateProfileSchema } from "@/schema/profile";
import { handleError } from "@/utils/error-handling";
import { getTokenFromRequest } from "@/utils/jwt-decode";
import { formatResponse } from "@/utils/response-formatter";
import { NextRequest, NextResponse } from "next/server";

export async function PUT(req: NextRequest) {
  try {
    const { id } = getTokenFromRequest(req);
    console.log(id);
    // Parsing body request
    const body = await req.json();
    const input = UpdateProfileSchema.parse(body);
    console.log(input);

    // Update profile
    const updatedProfile = await db.profile.update({
      where: {
        id,
      },
      data: {
        name: input.name,
        age: input.age,
        address: input.address,
        dob: input.dob,
        gender: input.gender,
        phone: input.phone,
      },
      select: {
        id: true,
        name: true,
        age: true,
        address: true,
        dob: true,
        gender: true,
        phone: true,
        created_at: true,
        updated_at: true,
      },
    });

    return NextResponse.json({
      success: true,
      message: "Profile updated successfully",
      data: updatedProfile,
    });
  } catch (error) {
    handleError(error);
  }
}

export async function GET(req: NextRequest) {
  try {
    const { id } = getTokenFromRequest(req);
    console.log(id); // Retrieve and validate token
    // Fetch profile
    const profile = await db.profile.findUnique({
      where: {
        id,
      },
      select: {
        id: true,
        name: true,
        age: true,
        address: true,
        dob: true,
        gender: true,
        phone: true,
        created_at: true,
        updated_at: true,
      },
    });

    if (!profile) {
      return NextResponse.json(
        { success: false, message: "Profile not found" },
        { status: 404 }
      );
    }

    return NextResponse.json({
      success: true,
      message: "Profile retrieved successfully",
      data: profile,
    });
  } catch (error) {
    return handleError(error);
  }
}

import db from "@/lib/db";
import { handleError } from "@/utils/error-handling";
import { formatResponse } from "@/utils/response-formatter";
import { NextRequest, NextResponse } from "next/server";
import { format } from "path";

export async function GET(req: NextRequest) {
  try {
    const services = await db.service.findMany({
      select: {
        id: true,
        name: true,
        price: true,
      },
    });
    return formatResponse(201, "Services retrieved successfully", services);
  } catch (error) {
    return handleError(error);
  }
}

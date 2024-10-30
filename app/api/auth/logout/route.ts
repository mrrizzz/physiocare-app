import { formatResponse } from "@/utils/response-formatter";
import { NextResponse } from "next/server";

export async function POST() {
  return formatResponse(200, "Logout successful");
}

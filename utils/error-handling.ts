import { NextResponse } from "next/server";
import { Prisma } from "@prisma/client";
import { ZodError } from "zod";

export function handleError(error: unknown): NextResponse {
  console.error("Error occurred: ", error);

  if (error instanceof ZodError) {
    const errorMessages = error.errors.map((err) => ({
      field: err.path.join("."),
      message: err.message,
    }));

    return NextResponse.json(
      {
        status: 400,
        message: "Invalid data",
        errors: errorMessages,
      },
      { status: 400 }
    );
  }

  if (error instanceof Prisma.PrismaClientKnownRequestError) {
    switch (error.code) {
      case "P2002":
        return NextResponse.json(
          {
            status: 409,
            message: "Email already in use",
            errors: error.meta?.target,
          },
          { status: 409 }
        );
      case "P2025":
        return NextResponse.json(
          {
            status: 404,
            message: "Data not found",
          },
          { status: 404 }
        );
      case "P2003":
        return NextResponse.json(
          {
            status: 400,
            message: "Failed to connect related data",
            errors: error.meta?.target,
          },
          { status: 400 }
        );
      case "P2014":
        return NextResponse.json(
          {
            status: 400,
            message: "Violation of relation constraint",
          },
          { status: 400 }
        );
      default:
        return NextResponse.json(
          {
            status: 500,
            message: "Unexpected database error",
            code: error.code,
          },
          { status: 500 }
        );
    }
  }

  if (error instanceof Error) {
    return NextResponse.json(
      {
        status: 500,
        message: error.message || "Internal server error",
      },
      { status: 500 }
    );
  }

  return NextResponse.json(
    {
      status: 500,
      message: "Unexpected error. Please contact administrator",
    },
    { status: 500 }
  );
}

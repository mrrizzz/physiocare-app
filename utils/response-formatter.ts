import { NextResponse } from "next/server";
import { MetaData, PaginationInfo, ResponseBody } from "./interface";
import { getPaginationMetadata } from "./pagination";

export function formatResponse<T>(
  statusCode: number,
  message: string,
  data?: T,
  token?: string,
  headers?: Record<string, string>,
  paginationInfo?: PaginationInfo
): NextResponse {
  const metadata: MetaData = paginationInfo
    ? getPaginationMetadata(paginationInfo)
    : {
        prev: null,
        next: null,
        current: "",
      };

  const responseBody: ResponseBody<T> = {
    payload: data,
    token,
    headers,
    message,
    metadata,
  } as ResponseBody<T>;

  return NextResponse.json([responseBody], { status: statusCode });
}

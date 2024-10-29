import { PaginationInfo, MetaData } from "./interface";

export const getPaginationMetadata = (
  paginationInfo: PaginationInfo
): MetaData => {
  const metadata: MetaData = {
    prev: null,
    next: null,
    current: "",
  };

  const { page, limit, totalItems, baseUrl } = paginationInfo;
  const totalPages = Math.ceil(totalItems / limit);
  let url = baseUrl;

  if (!url.endsWith("&")) {
    url += "?";
  }
  metadata.current = `${url}page=${page}&limit=${limit}`;

  if (page > 1) {
    metadata.prev = `${url}page=${page - 1}&limit=${limit}`;
  }

  if (page < totalPages) {
    metadata.next = `${url}page=${page + 1}&limit=${limit}`;
  }

  return metadata;
};

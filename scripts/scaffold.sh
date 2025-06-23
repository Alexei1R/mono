#!/usr/bin/env bash

set -e

BASE_PATH="src/features"

usage() {
  echo "Usage: $0 <feature-name> [base-path]"
  echo "  feature-name     Name of the feature (e.g., notes, invoice)"
  echo "  base-path        (Optional) Base path (default: src/features)"
}

if [ -z "$1" ]; then
  usage
  exit 1
fi

ELEMENT="$1"

if [ ! -z "$2" ]; then
  BASE_PATH="$2"
fi

FEATURE_PATH="$BASE_PATH/$ELEMENT"
SUBFOLDERS=(components hooks services store types constants)

mkdir -p "$FEATURE_PATH"
for SUB in "${SUBFOLDERS[@]}"; do
  mkdir -p "$FEATURE_PATH/$SUB"
  touch "$FEATURE_PATH/$SUB/index.ts"
done

# Main index barrel
cat > "$FEATURE_PATH/index.ts" <<EOF
export * from "./components";
export * from "./constants";
export * from "./hooks";
export * from "./services";
export * from "./store";
export * from "./types";
export { Component as ${ELEMENT^}Page } from "./${ELEMENT}.page";
export * from "./main";
EOF

# main.tsx
cat > "$FEATURE_PATH/main.tsx" <<MAIN
import React from "react";
const Main = () => (
  <div>
    <h1>${ELEMENT^} Feature Main</h1>
  </div>
);
export default Main;
MAIN

# Feature page
cat > "$FEATURE_PATH/${ELEMENT}.page.tsx" <<PAGE
import React from "react";
import Main from "./main";
const ${ELEMENT^}Page = () => {
  return (
    <div>
      <Main />
    </div>
  );
};
export const Component = ${ELEMENT^}Page;
PAGE

# Service sample
cat > "$FEATURE_PATH/services/${ELEMENT}.service.ts" <<SVC
import { api } from "@/shared/api";
const ${ELEMENT^^}_ROUTES = { GET: "/${ELEMENT}" };
export class ${ELEMENT^}Service {
  async getAll() {
    try {
      const { data } = await api.get(${ELEMENT^^}_ROUTES.GET);
      return { data, success: true };
    } catch (error) {
      return { error: error?.message || "Failed", success: false };
    }
  }
}
export const ${ELEMENT}Service = new ${ELEMENT^}Service();
SVC

# Store sample
cat > "$FEATURE_PATH/store/${ELEMENT}.store.ts" <<STORE
import { create } from "zustand";
export const use${ELEMENT^}Store = create((set) => ({
  items: [],
  setItems: (items) => set({ items }),
  clear: () => set({ items: [] }),
}));
STORE

# Hook sample
cat > "$FEATURE_PATH/hooks/use-${ELEMENT}.ts" <<HOOK
import { useQuery } from "@tanstack/react-query";
import { ${ELEMENT}Service } from "../services/${ELEMENT}.service";
import { use${ELEMENT^}Store } from "../store/${ELEMENT}.store";
export const use${ELEMENT^} = () => {
  const { items, setItems } = use${ELEMENT^}Store();
  const q = useQuery({
    queryKey: ["${ELEMENT}"],
    queryFn: async () => {
      const res = await ${ELEMENT}Service.getAll();
      if (!res.success) throw new Error(res.error || "Failed");
      setItems(res.data);
      return res.data;
    }
  });
  return { items, ...q };
};
HOOK

echo "done"


export const GET_UNVERIFIED_USERS = (state, documentSnapshot) => {
  state.unverifiedUsers = documentSnapshot
}

export const GET_USER = (state, documentSnapshot) => {
  state.user = documentSnapshot
}

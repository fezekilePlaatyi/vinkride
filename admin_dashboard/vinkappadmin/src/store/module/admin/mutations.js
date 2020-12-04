
export const GET_ADMINS = (state, admins) => {
  state.admins = admins.filter((admin) => {
    return admin.id !== state.admin.id
  })
}

export const GET_CURRENT_ADMIN = (state, admin) => {
  state.admin = admin
}

<template>
  <main class="registration-page">
    <div class="info display-flexed">
      <div>
        <span class="material-icons">account_circle</span>
        <div class="text">Регистрация</div>
      </div>
      <form id="registration-form" name="registration-form">
        <input type="text" id="login_in_reg_form" v-model="formData.login" :class="{discarded: hasError('login')}" placeholder="Ваш Логин" />
        <input
          type="text"
          id="password_primary"
          v-model="formData.password_primary"
          :class="{discarded: hasError('password_primary')}"
          placeholder="Пароль"
        />
        <input
          type="text"
          id="password_sustantional"
          v-model="formData.password_sustantional"
          :class="{discarded: hasError('password_sustantional')}"
          placeholder="Повторите пароль"
        />
      </form>
      <div>
        <button class="bottom-button" @click="validateForm">Отправить</button>
      </div>
    </div>
  </main>
</template>

<script setup>
import {ref, computed} from "vue";
import router from "@/router";
import {useStore} from "vuex";

const store = useStore();

const formData = ref({
  login: "",
  password_primary: "",
  password_sustantional: "",
});

const validate = ref({
  catches: false,
});

const validateFields = computed(() => {
  const errors = [];

  if (!validate.value.catches) return errors;

  if (!formData.value.login) errors.push({field: "login", message: ""});

  if (!formData.value.password_primary) errors.push({field: "password_primary", message: ""});

  if (!formData.value.password_sustantional || formData.value.password_sustantional != formData.value.password_primary)
    errors.push({field: "password_sustantional", message: ""});

  return errors;
});

function validateForm() {
  console.log("validating fields");
  validate.value.catches = true;
  if (!validateFields.value[0]) sendFormToServer();
}

function hasError(fieldName) {
  return validateFields.value.some((error) => error.field === fieldName);
}

function sendFormToServer() {
  console.log("Sending data to server");

  const registrationData = {
    login: formData.value.login,
    password_primary: formData.value.password_primary,
    password_sustaining: formData.value.password_sustantional,
  };

  fetch("http://localhost:8000/api/auth/register", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(registrationData),
  })
    .then((response) => response.json())
    .then((data) => {
      if (data["status"] === 400) {
        throw new Error(data["message"]);
      } else {
        store.state.account = data["data"];
        store.state.authenticated = true;
        router.push("/Account");
        return;
      }
    })
    .catch((error) => {
      console.error("Ошибка: ", error);
      return;
    });
}
</script>

<style lang="scss" scoped>
@keyframes error {
  50% {
    background-color: var(--error);
  }
  100% {
    background-color: var(--light);
  }
}

.discarded {
  transition: 0.2s ease-out;
  animation-name: error;
  animation-duration: 3s;
  animation-iteration-count: infinite;
}

.display-flexed {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.bottom-button {
  justify-self: flex-end;
  margin-bottom: 2rem;
}

button {
  color: var(--light);
  background-color: var(--dark);
  font-size: 2rem;
  border-radius: 0.5rem;
  width: 14rem;
  height: 3rem;
  margin: 1rem;
}

.material-icons {
  font-size: 4rem;
  margin-top: 2rem;
}

form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  align-items: center;

  .text {
    margin: 0rem;
    padding: 0rem;
  }
}

input {
  width: 20rem;
  height: 2rem;
  border-radius: 0.5rem;
  padding: 1rem;
  font-family: var(--font);
  background-color: var(--light);

  ::placeholder {
    color: var(--dark);
  }

  &::placeholder {
    text-align: center;
  }

  font-size: 1rem;
}
</style>

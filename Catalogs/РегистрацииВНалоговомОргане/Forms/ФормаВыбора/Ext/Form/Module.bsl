﻿// 4D:ERP для Беларуси
// {
// Форма изменена
// }
// 4D

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Параметры.Отбор.Свойство("Владелец", Организация);
	
	Элементы.Владелец.Видимость = НЕ ЗначениеЗаполнено(Организация);
	Элементы.Организация.Видимость = ЗначениеЗаполнено(Организация);
	
КонецПроцедуры

#КонецОбласти

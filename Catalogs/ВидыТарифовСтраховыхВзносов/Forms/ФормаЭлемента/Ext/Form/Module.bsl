﻿// 4D:ERP для Беларуси
// {
// Форма изменена
// }
// 4D

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоПросмотр = Истина;
	Элементы.Наименование.Подсказка = УчетСтраховыхВзносовКлиентСервер.ОписаниеВидаТарифа(Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

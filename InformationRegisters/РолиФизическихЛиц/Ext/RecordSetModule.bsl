﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		Запись.ИдентификаторЗаписи = Новый УникальныйИдентификатор;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

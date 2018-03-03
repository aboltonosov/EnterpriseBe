﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = ПараметрыСеанса.ТекущийПользователь;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный         = ПараметрыСеанса.ТекущийПользователь;
	ДатаНачала            = Неопределено;
	ДатаОкончания         = Неопределено;
	ПлановаяДатаНачала    = Неопределено;
	ПлановаяДатаОкончания = Неопределено;
	Завершено             = Ложь;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.СостоянияПредметовВзаимодействий.УстановитьПризнакАктивен(Ссылка, (НЕ Завершено) И (Не ПометкаУдаления));
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
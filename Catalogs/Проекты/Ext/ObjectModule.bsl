﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Завершен = Ложь;
	ПлановаяДатаНачала = ТекущаяДатаСеанса();
	ПлановаяДатаОкончания = Дата(1,1,1);
	ДатаНачала = ТекущаяДатаСеанса();
	ПлановаяДатаОкончания = Дата(1,1,1);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.СостоянияПредметовВзаимодействий.УстановитьПризнакАктивен(Ссылка, (НЕ Завершен) И (Не ПометкаУдаления));
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ПлановаяДатаОкончания)
		И ПлановаяДатаНачала > ПлановаяДатаОкончания Тогда
		
		ТекстСообщения = НСтр("ru = 'Плановая дата окончания не должна быть меньше плановой даты начала.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,
		                                                  ЭтотОбъект,
		                                                  "ПлановаяДатаОкончания",
		                                                  ,
		                                                  Отказ);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаОкончания)
		И ДатаНачала > ДатаОкончания Тогда
		
		ТекстСообщения = НСтр("ru = 'Дата окончания не должна быть меньше даты начала.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,
		                                                  ЭтотОбъект,
		                                                  "ДатаОкончания",
		                                                  ,
		                                                  Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
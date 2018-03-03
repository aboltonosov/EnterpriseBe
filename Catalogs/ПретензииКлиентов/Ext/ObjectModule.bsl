﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Партнер") Тогда
			
			Партнер = ДанныеЗаполнения.Партнер;
			
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Ответственный") Тогда
			
			Ответственный = ДанныеЗаполнения.Ответственный;
			
		КонецЕсли;
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказКлиента")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ВозвратТоваровОтКлиента")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ОтчетКомиссионера")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.РеализацияУслугПрочихАктивов")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.АктВыполненныхРабот") Тогда
		
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Партнер, КонтактноеЛицо");
		Партнер = РеквизитыОснования.Партнер;
		Если ЗначениеЗаполнено(РеквизитыОснования.КонтактноеЛицо) Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыОснования);
			НоваяСтрока = ПартнерыИКонтактныеЛица.Добавить();
			НоваяСтрока.Партнер = Партнер;
			НоваяСтрока.КонтактноеЛицо = РеквизитыОснования.КонтактноеЛицо;
		КонецЕсли;
		Основание = ДанныеЗаполнения;
		
	ИначеЕсли  ТипДанныхЗаполнения = Тип("ДокументСсылка.ОтчетКомиссионераОСписании")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.КорректировкаРеализации") Тогда
		
		Партнер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "Партнер");
		Основание = ДанныеЗаполнения;
		
	ИначеЕсли  ТипДанныхЗаполнения = Тип("СправочникСсылка.Партнеры") Тогда
		
		Партнер = ДанныеЗаполнения;
		
	ИначеЕсли ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(ДанныеЗаполнения) Тогда
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда
			
			РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Текст, Тема");
			Описание     = РеквизитыОснования.Текст;
			Наименование = РеквизитыОснования.Тема;
		Иначе
			Описание = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "Описание");
		КонецЕсли;
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.СделкиСКлиентами") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	СделкиСКлиентами.Партнер КАК Партнер
		|ИЗ
		|	Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|ГДЕ
		|	СделкиСКлиентами.Ссылка = &Сделка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СделкиСКлиентамиПартнерыИКонтактныеЛица.Партнер,
		|	СделкиСКлиентамиПартнерыИКонтактныеЛица.РольПартнера,
		|	СделкиСКлиентамиПартнерыИКонтактныеЛица.КонтактноеЛицо,
		|	СделкиСКлиентамиПартнерыИКонтактныеЛица.РольКонтактногоЛица
		|ИЗ
		|	Справочник.СделкиСКлиентами.ПартнерыИКонтактныеЛица КАК СделкиСКлиентамиПартнерыИКонтактныеЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|		ПО СделкиСКлиентамиПартнерыИКонтактныеЛица.Ссылка = СделкиСКлиентами.Ссылка
		|			И СделкиСКлиентамиПартнерыИКонтактныеЛица.Партнер = СделкиСКлиентами.Партнер
		|	И  СделкиСКлиентами.Ссылка = &Сделка
		|";
		
		Запрос.УстановитьПараметр("Сделка", ДанныеЗаполнения);
		
		Результат = Запрос.ВыполнитьПакет();
		ВыборкаПартнер = Результат[0].Выбрать();
		
		Если ВыборкаПартнер.Следующий() Тогда
			
			Партнер = ВыборкаПартнер.Партнер;
			
		КонецЕсли;
		
		ПартнерыИКонтактныеЛица.Загрузить(Результат[1].Выгрузить());
		
	КонецЕсли;
	
	ДатаРегистрации = ТекущаяДатаСеанса();
	Статус = Перечисления.СтатусыПретензийКлиентов.Зарегистрирована;
	ДатаОкончания = Дата(1,1,1);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Статус = Перечисления.СтатусыПретензийКлиентов.Зарегистрирована Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПричинаВозникновения");
	КонецЕсли;
	
	Если Статус = Перечисления.СтатусыПретензийКлиентов.Зарегистрирована ИЛИ Статус = Перечисления.СтатусыПретензийКлиентов.Обрабатывается Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаОкончания");
		МассивНепроверяемыхРеквизитов.Добавить("РезультатыОтработки");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПартнерыИКонтактныеЛица.Партнер");
		Для ТекИндекс = 0 По ПартнерыИКонтактныеЛица.Количество() - 1 Цикл
			Если Не ЗначениеЗаполнено(ПартнерыИКонтактныеЛица[ТекИндекс].Партнер) Тогда
				
				АдресОшибки = " " + НСтр("ru='в строке %НомерСтроки% списка ""Участники""'");
				АдресОшибки = СтрЗаменить(АдресОшибки, "%НомерСтроки%", ПартнерыИКонтактныеЛица[ТекИндекс].НомерСтроки);
				
				ТекстОшибки = НСтр("ru='Не заполнена колонка ""Контрагент""'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки + АдресОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПартнерыИКонтактныеЛица", ПартнерыИКонтактныеЛица[ТекИндекс].НомерСтроки, "Партнер"),
					,
					Отказ);
					
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если (Статус = Перечисления.СтатусыПретензийКлиентов.Зарегистрирована)
	     Или (Статус = Перечисления.СтатусыПретензийКлиентов.Обрабатывается) Тогда
		ДатаОкончания = Дата(1, 1, 1);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПретензияАктивна = (Не ПометкаУдаления) И ((Статус = Перечисления.СтатусыПретензийКлиентов.Зарегистрирована)
	                   Или (Статус = Перечисления.СтатусыПретензийКлиентов.Обрабатывается));
	
	РегистрыСведений.СостоянияПредметовВзаимодействий.УстановитьПризнакАктивен(Ссылка, ПретензияАктивна);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

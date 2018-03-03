﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЭтотОбъект.Дата = ТекущаяДатаСеанса();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ЭтапыПодготовкиБюджетов") Тогда
		Реквизиты = Новый Структура();
		Реквизиты.Вставить("МодельБюджетирования", "Владелец");
		Реквизиты.Вставить("Действие", "Действие");
		Реквизиты.Вставить("Наименование", "Наименование");
		Реквизиты.Вставить("НастройкаДействия", "НастройкаДействия");
		Реквизиты.Вставить("НастройкиКонтрольныхОтчетов", "НастройкиКонтрольныхОтчетов");
		Реквизиты.Вставить("ОписаниеЗадачи", "ОписаниеЗадачи");
		Реквизиты.Вставить("ЭтапПодготовкиБюджетов", "Ссылка");
		Реквизиты.Вставить("Исполнитель", "Ответственный");
		Реквизиты.Вставить("Периодичность", "Родитель.Периодичность");
		ЗначениеРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, Реквизиты);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначениеРеквизитов);
		Задачи.БюджетнаяЗадача.УстановитьДлительностьЗадачи(ЭтотОбъект, ДанныеЗаполнения);
		Если Не ЗначениеЗаполнено(ЭтотОбъект.Период) Тогда
			ЭтотОбъект.Период =
				БюджетированиеКлиентСервер.ДатаНачалаПериода(ТекущаяДатаСеанса(), ЗначениеРеквизитов.Периодичность);
		КонецЕсли;
		ДополнительныеСвойства.Вставить("НастройкаДействия",
			ЗначениеРеквизитов.НастройкаДействия.Получить());
		ДополнительныеСвойства.Вставить("НастройкиКонтрольныхОтчетов",
			ЗначениеРеквизитов.НастройкиКонтрольныхОтчетов.Получить());
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ЭтотОбъект.МодельБюджетирования) 
		И (ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("МодельБюджетирования")) Тогда
		ЭтотОбъект.МодельБюджетирования = Справочники.МоделиБюджетирования.МодельБюджетированияПоУмолчанию();
	КонецЕсли;
	
	ТаблицаУтверждаемыхДокументов =
		Задачи.БюджетнаяЗадача.УтверждаемыеДокументыПоШагуПроцесса(Действие, НастройкаДействия.Получить(), Период);
		
	УтверждаемыеДокументы.Загрузить(ТаблицаУтверждаемыхДокументов);
	
	Автор = ПользователиКлиентСервер.АвторизованныйПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Ошибки;
	
	Если КонецДня(СрокИсполнения) < Дата Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			Ошибки, "Объект.СрокИсполнения", НСтр("ru = 'Срок не может быть меньше даты назначения!'"), "");
	КонецЕсли;
	
	ЭтапПроверки = ?(ЗначениеЗаполнено(ЭтапПодготовкиБюджетовОснование), ЭтапПодготовкиБюджетовОснование, ЭтапПодготовкиБюджетов);
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтапПроверки, "ВыполнятьАвтоматически") = Ложь Тогда
		ПроверяемыеРеквизиты.Добавить("Исполнитель");
	КонецЕсли;
	
	Если Выполнена Тогда
		
		Если ЗначениеЗаполнено(ДатаИсполнения) И ДатаИсполнения < Дата Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
				Ошибки, "Объект.ДатаИсполнения", НСтр("ru = 'Дата исполнения не может быть меньше даты назначения!'"), "");
		КонецЕсли;
		
		ПараметрыОпции = Новый Структура("МодельБюджетирования", МодельБюджетирования);
		ИспользоватьУтверждениеБюджетов = ПолучитьФункциональнуюОпцию("ИспользоватьУтверждениеБюджетов", ПараметрыОпции); 
		
		ЭтоСвязаннаяЗадача = ЗначениеЗаполнено(ОсновнаяЗадача);
		УстановитьПривилегированныйРежим(Истина);
		ОсновнаяЗадачаДействие = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОсновнаяЗадача, "Действие");
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ИспользоватьУтверждениеБюджетов И (Не ЭтоСвязаннаяЗадача 
			ИЛИ ОсновнаяЗадачаДействие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.УтверждениеБюджетов) Тогда
			
			Если СписокДокументов.Количество()
				И (Действие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ВводПлана
					ИЛИ Действие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ВводБюджетов) Тогда
				МассивДокументов = СписокДокументов.ВыгрузитьКолонку("Документ");
				РеквизитыДокументов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивДокументов, "Статус, Проведен");
				Для Каждого РеквизитыДокумента Из РеквизитыДокументов Цикл
					Если РеквизитыДокумента.Значение.Статус = Перечисления.СтатусыПланов.ВПодготовке
						ИЛИ Не РеквизитыДокумента.Значение.Проведен Тогда
						ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
							Ошибки, "",
							СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Для выполнения задачи документ %1 должен быть проведен в статусе ""На утверждении""'"),
								РеквизитыДокумента.Ключ), "");
					КонецЕсли;
				КонецЦикла;
				
			ИначеЕсли Действие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.УтверждениеБюджетов Тогда
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	УтверждаемыеДокументы.НомерСтроки,
				|	УтверждаемыеДокументы.Документ,
				|	УтверждаемыеДокументы.ЭтапПодготовкиБюджетов
				|ПОМЕСТИТЬ УтверждаемыеДокументы
				|ИЗ
				|	&УтверждаемыеДокументы КАК УтверждаемыеДокументы
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	УтверждаемыеДокументы.НомерСтроки КАК НомерСтроки,
				|	УтверждаемыеДокументы.Документ,
				|	ВЫБОР
				|		КОГДА НЕ ЭкземплярБюджета.Ссылка ЕСТЬ NULL 
				|			ТОГДА ЭкземплярБюджета.Статус
				|		КОГДА НЕ ПланЗакупок.Ссылка ЕСТЬ NULL 
				|			ТОГДА ПланЗакупок.Статус
				|		КОГДА НЕ ПланПродаж.Ссылка ЕСТЬ NULL 
				|			ТОГДА ПланПродаж.Статус
				|		КОГДА НЕ ПланПроизводства.Ссылка ЕСТЬ NULL 
				|			ТОГДА ПланПроизводства.Статус
				|		КОГДА НЕ ПланСборкиРазборки.Ссылка ЕСТЬ NULL 
				|			ТОГДА ПланСборкиРазборки.Статус
				|	КОНЕЦ КАК Статус,
				|	ВЫБОР
				|		КОГДА НЕ ЭкземплярБюджета.Ссылка ЕСТЬ NULL 
				|			ТОГДА ЭкземплярБюджета.Проведен
				|		КОГДА НЕ ПланЗакупок.Ссылка ЕСТЬ NULL 
				|			ТОГДА ПланЗакупок.Проведен
				|		КОГДА НЕ ПланПродаж.Ссылка ЕСТЬ NULL 
				|			ТОГДА ПланПродаж.Проведен
				|		КОГДА НЕ ПланПроизводства.Ссылка ЕСТЬ NULL 
				|			ТОГДА ПланПроизводства.Проведен
				|		КОГДА НЕ ПланСборкиРазборки.Ссылка ЕСТЬ NULL 
				|			ТОГДА ПланСборкиРазборки.Проведен
				|	КОНЕЦ КАК Проведен
				|ИЗ
				|	УтверждаемыеДокументы КАК УтверждаемыеДокументы
				|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЭтапыПодготовкиБюджетов КАК ЭтапыПодготовкиБюджетов
				|		ПО УтверждаемыеДокументы.ЭтапПодготовкиБюджетов = ЭтапыПодготовкиБюджетов.Ссылка
				|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЭкземплярБюджета КАК ЭкземплярБюджета
				|		ПО УтверждаемыеДокументы.Документ = ЭкземплярБюджета.Ссылка
				|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПланЗакупок КАК ПланЗакупок
				|		ПО УтверждаемыеДокументы.Документ = ПланЗакупок.Ссылка
				|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПланПродаж КАК ПланПродаж
				|		ПО УтверждаемыеДокументы.Документ = ПланПродаж.Ссылка
				|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПланПроизводства КАК ПланПроизводства
				|		ПО УтверждаемыеДокументы.Документ = ПланПроизводства.Ссылка
				|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПланСборкиРазборки КАК ПланСборкиРазборки
				|		ПО УтверждаемыеДокументы.Документ = ПланСборкиРазборки.Ссылка
				|ГДЕ
				|	(НЕ ВЫБОР
				|					КОГДА НЕ ЭкземплярБюджета.Ссылка ЕСТЬ NULL 
				|						ТОГДА ЭкземплярБюджета.Статус
				|					КОГДА НЕ ПланЗакупок.Ссылка ЕСТЬ NULL 
				|						ТОГДА ПланЗакупок.Статус
				|					КОГДА НЕ ПланПродаж.Ссылка ЕСТЬ NULL 
				|						ТОГДА ПланПродаж.Статус
				|					КОГДА НЕ ПланПроизводства.Ссылка ЕСТЬ NULL 
				|						ТОГДА ПланПроизводства.Статус
				|					КОГДА НЕ ПланСборкиРазборки.Ссылка ЕСТЬ NULL 
				|						ТОГДА ПланСборкиРазборки.Статус
				|				КОНЕЦ В (ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Утвержден), ЗНАЧЕНИЕ(Перечисление.СтатусыПланов.Отменен))
				|			ИЛИ ВЫБОР
				|				КОГДА НЕ ЭкземплярБюджета.Ссылка ЕСТЬ NULL 
				|					ТОГДА ЭкземплярБюджета.Проведен
				|				КОГДА НЕ ПланЗакупок.Ссылка ЕСТЬ NULL 
				|					ТОГДА ПланЗакупок.Проведен
				|				КОГДА НЕ ПланПродаж.Ссылка ЕСТЬ NULL 
				|					ТОГДА ПланПродаж.Проведен
				|				КОГДА НЕ ПланПроизводства.Ссылка ЕСТЬ NULL 
				|					ТОГДА ПланПроизводства.Проведен
				|				КОГДА НЕ ПланСборкиРазборки.Ссылка ЕСТЬ NULL 
				|					ТОГДА ПланСборкиРазборки.Проведен
				|			КОНЕЦ = ЛОЖЬ)
				|
				|УПОРЯДОЧИТЬ ПО
				|	НомерСтроки";
				Запрос.УстановитьПараметр("УтверждаемыеДокументы", УтверждаемыеДокументы.Выгрузить());
				Запрос.УстановитьПараметр("СтатусУтвержден", Перечисления.СтатусыПланов.Утвержден);
				
				Выборка = Запрос.Выполнить().Выбрать();
				Пока Выборка.Следующий() Цикл
					
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Для выполнения задачи необходимо документ %1 провести в статусах ""Утвержден"" или ""Отклонен""'"),
						Выборка.Документ);
						
					ПолеОшибки = "Объект." 
						+ ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
						"УтверждаемыеДокументы", Выборка.НомерСтроки, "Документ");
					
					ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, ПолеОшибки, ТекстСообщения, "");
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаИсполнения) И Выполнена Тогда
		ДатаИсполнения = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОповещенияДляЗадачБюджетирования")
		И Ссылка.Пустая() Тогда
		ДополнительныеСвойства.Вставить("СоздатьОповещениеНаПоступлениеЗадачи", Истина);
	КонецЕсли;
	
	РедактированиеБюджетныхЗадачВнеПроцессов = РольДоступна("РедактированиеБюджетныхЗадачВнеПроцессов")
		ИЛИ Пользователи.ЭтоПолноправныйПользователь(, , Истина);
	
	Если Не РедактированиеБюджетныхЗадачВнеПроцессов Тогда
		ТекстОшибки = "";
		Если Не ЗначениеЗаполнено(ОсновнаяЗадача) И (Не ЗначениеЗаполнено(Ссылка) ИЛИ Исполнитель <> Пользователи.ТекущийПользователь()  
			ИЛИ Исполнитель <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Исполнитель") ) Тогда
			ТекстОшибки = НСтр("ru='В рамках бюджетного процесса разрешено создавать/изменять только связанные задачи.'");
		ИначеЕсли ЗначениеЗаполнено(ОсновнаяЗадача) И Действие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ВводБюджетов 
			И (Не ЗначениеЗаполнено(Ссылка) ИЛИ Исполнитель <> Пользователи.ТекущийПользователь()  
				ИЛИ Исполнитель <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Исполнитель") ) Тогда
			ТекстОшибки = НСтр("ru='В рамках бюджетного процесса запрещено создавать/изменять задачи на ввод бюджета.'");
		КонецЕсли;
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, , , Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ДополнительныеСвойства.Свойство("РежимФормированияЗадач") Тогда
		Если Выполнена и Не ПометкаУдаления Тогда
			Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
				Задачи.БюджетнаяЗадача.ФормированиеБюджетныхЗадач(МодельБюджетирования,ПроцессПодготовкиБюджетов);
			Иначе
				ПараметрыЗадания = Новый Массив();
				ПараметрыЗадания.Добавить(МодельБюджетирования);
				ПараметрыЗадания.Добавить(ПроцессПодготовкиБюджетов);
				ФоновыеЗадания.Выполнить("БюджетированиеСервер.ФормированиеБюджетныхЗадач",ПараметрыЗадания);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("СоздатьОповещениеНаПоступлениеЗадачи") Тогда
		ФоновыеЗадания.Выполнить(Метаданные.РегламентныеЗадания.ФормированиеОповещенийПоБюджетнымЗадачам.ИмяМетода);
	ИначеЕсли Выполнена ИЛИ ПометкаУдаления Тогда
		НаборЗаписей = РегистрыСведений.ОтправленныеОповещенияПоБюджетнымЗадачам.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.БюджетнаяЗадача.Установить(Ссылка);
		НаборЗаписей.Записать();
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
﻿////////////////////////////////////////////////////////////////////////////////
// Управление производством: содержит процедуры для управления производством.
// Модуль входит в подсистему "УправлениеПредприятием".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОповещенияПользователей

// Оповещает пользователя о завершении процесса передачи этапов к выполнению.
//
// Параметры:
//  Результат	 - Структура			 - результат передачи этапов к выполнению
//  Источник	 - УникальныйИдентификатор	 - идентификатор формы, инициировавшей создание документов.
//
Процедура ОповеститьПользователяОПередачиЭтаповКВыполнению(Результат, Источник = Неопределено) Экспорт
	
	Если Результат.Количество > 0 Тогда
		
		ТекстДокументов = ОбщегоНазначенияУТКлиентСервер.ФормаМножественногоЧисла(
				НСтр("ru='документ'"), НСтр("ru='документа'"), НСтр("ru='документов'"), Результат.Количество);
		
		ТекстСообщения = НСтр("ru='Передано к выполнению %Количество% %ТекстДокументов%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Количество%", Результат.Количество);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТекстДокументов%", ТекстДокументов);
		ТекстЗаголовка = НСтр("ru='Этапы производства переданы к выполнению'");
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Ни один документ не передан к выполнению'");
		ТекстЗаголовка = НСтр("ru='Этапы производства не переданы к выполнению'");
		
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Оповещает пользователя о завершении процесса создания этапов производства.
//
// Параметры:
//  РезультатФормирования	 - Структура - результат формирования этапов.
//  Источник				 - УникальныйИдентификатор - идентификатор формы, инициировавшей создание документов.
//
Процедура ОповеститьПользователяОФормированииЭтаповПроизводства(РезультатФормирования, Источник = Неопределено) Экспорт
	
	Ссылка = Неопределено;
	Картинка = БиблиотекаКартинок.Информация32;
	
	Если РезультатФормирования.СформированоДокументов > 0 Тогда
		
		ТекстЗаголовка = НСтр("ru='Этапы сформированы'");
		
		ТекстДокументов = ОбщегоНазначенияУТКлиентСервер.ФормаМножественногоЧисла(
				НСтр("ru='документ'"),
				НСтр("ru='документа'"),
				НСтр("ru='документов'"),
				РезультатФормирования.СформированоДокументов);
		
		ТекстСообщения = НСтр("ru='Сформировано %КоличествоОбработанных% %ТекстДокументов%'");
		ТекстСообщения = СтрЗаменить(
			ТекстСообщения,
			"%КоличествоОбработанных%",
			РезультатФормирования.СформированоДокументов);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТекстДокументов%", ТекстДокументов);
		
	ИначеЕсли РезультатФормирования.ЕстьОшибка Тогда
		
		ТекстЗаголовка = НСтр("ru='Этапы не сформированы'");
		ТекстСообщения = РезультатФормирования.ОшибкаТекст;
		
		Ссылка = ПолучитьНавигационнуюСсылку(РезультатФормирования.ОшибкаСсылка);
		Картинка = БиблиотекаКартинок.Ошибка32;
		
	Иначе
		
		ТекстЗаголовка = НСтр("ru='Этапы не сформированы'");
		ТекстСообщения = НСтр("ru='Не сформирован ни один документ'");
		
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстЗаголовка, Ссылка, ТекстСообщения, Картинка);
	
КонецПроцедуры

// Оповещает пользователя о завершении процесса планирования графика производства.
//
// Параметры:
//  Результат	 - Структура - результат планирования графика производства.
//  Источник	 - УникальныйИдентификатор	 - идентификатор формы, инициировавшей создание документов.
//
Процедура ОповеститьПользователяОПланированииГрафикаПроизводства(Результат, Источник = Неопределено) Экспорт
	
	Если Результат.ЕстьОшибки Тогда
		
		Если Результат.КоличествоОбработанных > 0 Тогда
			ТекстЗаголовка = НСтр("ru='Запланировано %КоличествоОбработанных% из %КоличествоВсего% документов'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%КоличествоОбработанных%", Результат.КоличествоОбработанных);
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%КоличествоВсего%",        Результат.КоличествоВсего);
		Иначе
			ТекстЗаголовка = НСтр("ru='График производства не запланирован'");
		КонецЕсли;
		
		ТекстСообщения = НСтр("ru='Не удалось запланировать документ'")
						+ " " 
						+ Строка(Результат.РаспоряжениеОшибка);
		
	Иначе
		
		Если Результат.КоличествоОбработанных > 0 Тогда
			
			ТекстСообщения = НСтр("ru='Запланировано %КоличествоОбработанных% из %КоличествоВсего% документов'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоОбработанных%", Результат.КоличествоОбработанных);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоВсего%",        Результат.КоличествоВсего);
			ТекстЗаголовка = НСтр("ru='График производства запланирован'");
			
		Иначе
			
			ТекстСообщения = НСтр("ru='Не запланирован ни один документ'");
			ТекстЗаголовка = НСтр("ru='График производства не запланирован'");
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Оповещает пользователя о завершении процесса пометки на удаление этапов к выполнению.
//
// Параметры:
//  Результат - Структура - результат выполнения операции
//
Процедура ОповеститьПользователяОПометкеНаУдалениеЭтаповПроизводства(Результат) Экспорт
	
	ОшибкаСсылка = Неопределено;
	
	Если Результат.КоличествоОбработано > 0 ИЛИ Результат.ЕстьОшибки Тогда
		
		ТекстДокументов = ОбщегоНазначенияУТКлиентСервер.ФормаМножественногоЧисла(
				НСтр("ru='документ'"),
				НСтр("ru='документа'"),
				НСтр("ru='документов'"),
				Результат.КоличествоОбработано);
	
		Если Результат.ЕстьОшибки Тогда
			ТекстЗаголовка = НСтр("ru='Ошибка установки пометки на удаления этапов!'");
			ТекстШаблон = НСтр("ru='При пометке на удаление цепочки этапов %1 возникла ошибка! Помечено на удаление %2 %3.'");
			ТекстСообщения = СтрШаблон(ТекстШаблон,Результат.ОшибкаСсылка,Формат(Результат.КоличествоОбработано,"ЧН=; ЧГ="),ТекстДокументов);
		Иначе
			ТекстЗаголовка = НСтр("ru='Этапы производства помечены на удаление.'");
			ТекстШаблон = НСтр("ru='Помечено на удаление %1 %2'");
			ТекстСообщения = СтрШаблон(ТекстШаблон,Формат(Результат.КоличествоОбработано,"ЧН=; ЧГ="),ТекстДокументов);
		КонецЕсли;
		
		Если Результат.ЕстьОшибки Тогда 
			ОшибкаСсылка = ПолучитьНавигационнуюСсылку(Результат.ОшибкаСсылка);
		КонецЕсли;
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Ни один документ не помечен на удаление'");
		ТекстЗаголовка = НСтр("ru='Не удалось пометить на удаление этапы производства'");
		
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстЗаголовка, ОшибкаСсылка, ТекстСообщения, БиблиотекаКартинок.Информация32);	
	
КонецПроцедуры

#КонецОбласти

#Область ОткрытиеФорм

// Открывает заказ на производство с выделением строки продукции
//
// Параметры:
//  Заказ		 - ДокументСсылка.ЗаказНаПроизводство2_2 - заказ на производство
//  ДанныеСтроки - Структура							 - см. УправлениеПроизводствомКлиентСервер.СтруктураПродукцииЗаказа()
//  Форма		 - УправляемаяФорма						 - форма из которой выполняется переход
//
Процедура ОткрытьСтрокуЗаказаНаПроизводства(Заказ, ДанныеСтроки, Форма) Экспорт
	
	Параметры = Новый Структура("Ключ, ВыбраннаяСтрока", Заказ, ДанныеСтроки);
	ОткрытьФорму("Документ.ЗаказНаПроизводство2_2.ФормаОбъекта", Параметры, Форма);
	
КонецПроцедуры

// Открывает очередь заказов
//
// Параметры:
//  СтруктураОтборов - Структура							 - устанавливаемые отборы
//  ТекущаяСтрока	 - ДокументСсылка.ЗаказНаПроизводство2_2 - заказ на производство
//  Форма			 - УправляемаяФорма						 - форма из которой выполняется переход
//
Процедура ОткрытьОчередьЗаказов(СтруктураОтборов = Неопределено, ТекущаяСтрока = Неопределено, Форма = Неопределено) Экспорт
	
	Параметры = Новый Структура;
	Если СтруктураОтборов <> Неопределено Тогда
		Параметры.Вставить("СтруктураОтборов", СтруктураОтборов);
	КонецЕсли;
	Если ТекущаяСтрока <> Неопределено Тогда
		Параметры.Вставить("ТекущаяСтрока", ТекущаяСтрока);
	КонецЕсли;
	ОткрытьФорму("Документ.ЗаказНаПроизводство2_2.Форма.УправлениеОчередьюЗаказов", Параметры, Форма);
	
КонецПроцедуры

// Открывает форму выбоора потребностей в производстве
//
// Параметры:
//  Объект				 - ДокументОбъект.ЭтапПроизводства2_2	 - этап
//  ТекущаяСтрока		 - Структура							 - данные текущей строки
//  Форма				 - УправляемаяФорма						 - форма в которой выполняется выбор
//  ОписаниеОповещения	 - ОписаниеОповещения					 - содержит описание процедуры, которая будет вызвана при закрытии формы
//
Процедура ОткрытьФормуВыбораПотребностейВПроизводстве(Объект, ТекущаяСтрока, Форма, ОписаниеОповещения = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("Распоряжение", Объект.Распоряжение);

	ПараметрыФормы.Вставить("Номенклатура", ТекущаяСтрока.Номенклатура);
	ПараметрыФормы.Вставить("Характеристика", ТекущаяСтрока.Характеристика);

	ПараметрыФормы.Вставить("ВыпускающийЭтап", Объект.ВыпускающийЭтап);
	ПараметрыФормы.Вставить("НазначениеПродукция", Объект.НазначениеПродукция);
	
	ПараметрыФормы.Вставить("Спецификация", Объект.Спецификация);
	ПараметрыФормы.Вставить("Получатель", ТекущаяСтрока.Получатель);
	
	ПараметрыФормы.Вставить("НаправлениеДеятельности", Объект.НаправлениеДеятельности);
	
	ПараметрыФормы.Вставить("Партнер", Объект.Партнер);
	ПараметрыФормы.Вставить("Договор", Объект.Договор);
	
	ПараметрыФормы.Вставить("Источник", Объект.Ссылка);
	
	ОткрытьФорму("Справочник.Назначения.Форма.ФормаВыбораПоПотребностямВПроизводстве",
		ПараметрыФормы,
		Форма,
		,
		,
		,
		ОписаниеОповещения);
	
КонецПроцедуры

// Открывает последовательность этапов в цепочке
//
// Параметры:
//  Заказ			 - ДокументСсылка.ЗаказНаПроизводство2_2 - заказ на производство
//  ВыпускающийЭтап	 - ДокументСсылка.ЭтапПроизводства2_2	 - этап
//  Потребность		 - Структура							 - см. УправлениеПроизводствомКлиентСервер.СтруктураПотребностиПроизводства()
//  Форма			 - УправляемаяФорма						 - форма из которой выполняется переход
//
Процедура ОткрытьПоследовательностьЭтапов(Заказ, ВыпускающийЭтап = Неопределено, Потребность = Неопределено, Форма = Неопределено) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Распоряжение", Заказ);
	Если ВыпускающийЭтап <> Неопределено Тогда
		Параметры.Вставить("ВыпускающийЭтап",ВыпускающийЭтап);
	КонецЕсли;
	Если Потребность <> Неопределено Тогда
		Параметры.Вставить("Потребность",Потребность);
	КонецЕсли;
	ОткрытьФорму("Документ.ЭтапПроизводства2_2.Форма.ПоследовательностьЭтапов", Параметры, Форма);
	
КонецПроцедуры

#КонецОбласти

#Область ВыполнениеОпераций

// Открывает рабочее место "Выполнение операций" с отбором по этапу производства
//
// Параметры:
//  Этап	 - ДокументСсылка.ЭтапПроизводства2_2	 - этап производства
//  Форма	 - УправляемаяФорма						 - форма из которой выполняется переход
//
Процедура ОткрытьВыполнениеОпераций(Этап, Форма) Экспорт
	
	Параметры = Новый Структура("ОтборЭтап", Этап);
	ОткрытьФорму("Обработка.ВыполнениеОпераций2_2.Форма.РабочееМесто", Параметры, Форма);
	
КонецПроцедуры

#КонецОбласти

#Область Аналоги

// Процедура - Открыть выбор аналогов
//
// Параметры:
//  ПараметрыВыбораАналогов	 - Структура - содержит параметры выбора (см функцию УправлениеПроизводствомКлиент.ПараметрыВыбораАналогов)
//  Форма					 - УправляемаяФорма - форма в которой выполняется выбор аналогов (после выбора будет вызвано событие ОбработкаВыбора())
//
Процедура ОткрытьПодборАналогов(ПараметрыВыбораАналогов, Форма) Экспорт
	
	ОткрытьФорму("Документ.РазрешениеНаЗаменуМатериалов.Форма.ПодборАналогов", ПараметрыВыбораАналогов, Форма);
	
КонецПроцедуры

#КонецОбласти

#Область СтатьиНаИТС

// Выполняет переход по ссылке на статью "5 шагов к производству версии 2.2"
//
Процедура ОткрытьСтатью5ШаговКПроизводству22() Экспорт
	
	ОбщегоНазначенияКлиент.ПерейтиПоСсылке("http://its.1c.ru/db/metod81#content:6511:hdoc");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РедактированиеЭтапаПроизводства

Процедура ВыходныеИзделияЭтапаПриНачалеРедактирования(Форма, ТекущиеДанные, НоваяСтрока, Копирование) Экспорт
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные.КодСтроки = 0;
		
		СкладыКлиентСервер.ЗаполнитьСкладПоУмолчанию(
				Форма.ИспользоватьНесколькоСкладов, 
				Форма.СкладПоУмолчанию, 
				ТекущиеДанные,
				"Получатель");
				
	КонецЕсли;

КонецПроцедуры

Процедура ВыходныеИзделияЭтапаПолучательПриИзменении(ТекущиеДанные, КэшированныеЗначения) Экспорт
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьТипСклада", Новый Структура("Склад,ТипСклада", "Получатель", "ТипСклада"));
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

Процедура ПобочныеИзделияЭтапаСуммаПриИзменении(ТекущиеДанные, КэшированныеЗначения) Экспорт
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьЦенуПоСумме");
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

Процедура ПобочныеИзделияЭтапаЦенаПриИзменении(ТекущиеДанные, КэшированныеЗначения) Экспорт

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСумму");
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

Процедура ПроизводитсяПриИзменении(ТекущиеДанные, Объект, ПараметрыУказанияСерий, КэшированныеЗначения) Экспорт
	
	Если ТекущиеДанные.Производится Тогда
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПроверитьЗаполнитьСпецификацию", Новый Структура("Подразделение,Дата", Объект.Подразделение, Объект.Дата));
		УправлениеПроизводствомКлиентСервер.ДобавитьВСтруктуруДействияПроверитьЗаполнитьОбеспечениеВЭтапеПроизводства(
				Объект, ТекущиеДанные, ПараметрыУказанияСерий, СтруктураДействий);
				
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
		
	Иначе
		
		ТекущиеДанные.Спецификация = Неопределено;
		
		СтруктураДействий = Новый Структура;
		УправлениеПроизводствомКлиентСервер.ДобавитьВСтруктуруДействияПроверитьЗаполнитьОбеспечениеВЭтапеПроизводства(
				Объект, ТекущиеДанные, ПараметрыУказанияСерий, СтруктураДействий);
				
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбеспечениеМатериаламиИРаботамиЭтапаПриНачалеРедактирования(Форма, ТекущиеДанные, НоваяСтрока, Копирование) Экспорт
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные.КодСтроки = 0;
		
		СкладыКлиентСервер.ЗаполнитьСкладПоУмолчанию(
				Форма.ИспользоватьНесколькоСкладов, 
				Форма.СкладПоУмолчанию, 
				ТекущиеДанные);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбеспечениеМатериаламиИРаботамиЭтапаСпецификацияПриИзменении(Объект, ТекущиеДанные, ПараметрыУказанияСерий, КэшированныеЗначения) Экспорт
	
	СтруктураДействий = Новый Структура;
	
	УправлениеПроизводствомКлиентСервер.ДобавитьВСтруктуруДействияПроверитьЗаполнитьОбеспечениеВЭтапеПроизводства(
			Объект, ТекущиеДанные, ПараметрыУказанияСерий, СтруктураДействий);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

Процедура ОбеспечениеМатериаламиИРаботамиЭтапаСкладПриИзменении(ТекущиеДанные, ПараметрыУказанияСерий, КэшированныеЗначения) Экспорт
	
	Если ТекущиеДанные.Производится Тогда
		
		ТекущиеДанные.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Обособленно");
		
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.Склад) 
		И ТекущиеДанные.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.НеТребуется") Тогда
		
		ТекущиеДанные.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Требуется")
		
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", 
				Новый Структура("Склад, ПараметрыУказанияСерий", ТекущиеДанные.Склад, ПараметрыУказанияСерий));

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

Процедура ОбеспечениеМатериаламиИРаботамиЗаполнитьОбеспечение(Объект, ВыделенныеСтроки, Форма, ПутьМатериалыИУслуги) Экспорт

	ПараметрыПроверки = ОбеспечениеКлиентСервер.ИнициализироватьПараметрыПроверкиЗаполнения(
		"ОбеспечениеМатериаламиИРаботами", НСтр("ru = 'Обеспечение'"));
		
	ПараметрыПроверки.Поля.Удалить("Склад");
	ПараметрыПроверки.Поля.Удалить("Подразделение");
		
	ТаблицаМатериалыИУслуги = Объект.ОбеспечениеМатериаламиИРаботами;
	
	ИдентификаторыСтрок = Новый Массив();
	Для Каждого Идентификатор Из ВыделенныеСтроки Цикл

		ДанныеСтроки = ТаблицаМатериалыИУслуги.НайтиПоИдентификатору(Идентификатор);
		Если НЕ ИспользуетсяВариантОбеспечения(ДанныеСтроки) Тогда
			Продолжить;
		КонецЕсли;
		
		ИдентификаторыСтрок.Добавить(Идентификатор);
		
	КонецЦикла;

	Если ИдентификаторыСтрок.Количество() > 0 Тогда

		Если ОбеспечениеКлиентСервер.ПроверитьЗаполнение(Объект, ТаблицаМатериалыИУслуги, ИдентификаторыСтрок, ПараметрыПроверки) Тогда

			ПараметрыФормы = ОбеспечениеКлиентСервер.ПараметрыФормыИсполнениеЗаказа("ЭтапПроизводства2_2");
			ПараметрыФормы.СписокВыбора = УправлениеПроизводствомКлиентСервер.ДоступныеВариантыОбеспечения();
			
			ОткрытьФорму("Перечисление.ВариантыОбеспечения.Форма.ИсполнениеЗаказа", ПараметрыФормы, Форма);

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ПриИзмененииКоличестваУпаковокЭтапа(СтрокаТабличнойЧасти, ИмяТЧ, Форма, КэшированныеЗначения) Экспорт

	СтруктураДействий = Новый Структура;
	
	УправлениеПроизводствомКлиентСервер.ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(
		СтрокаТабличнойЧасти, 
		ИмяТЧ, 
		СтруктураДействий);
		
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтрокаТабличнойЧасти, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

Процедура ПриИзмененииУпаковки(СтрокаТабличнойЧасти, ИмяТЧ, Форма, КэшированныеЗначения) Экспорт

	СтруктураДействий = Новый Структура;
	
	ПараметрыПересчета = УправлениеПроизводствомКлиентСервер.ПараметрыПересчетаКоличестваЕдиниц();
	
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц", ПараметрыПересчета);
	
	Если ИмяТЧ = "ПобочныеИзделия" И Форма.ПараметрыРедактированияЭтапа.ИмяРеквизитаОбъект = "Объект" Тогда
		Если СтрокаТабличнойЧасти.Количество > 0 Тогда
			СтруктураДействий.Вставить("ПересчитатьЦенуЗаУпаковку", СтрокаТабличнойЧасти.Количество);
		Иначе
			УправлениеПроизводствомКлиентСервер.ДобавитьВСтруктуруДействияЗаполнитьЦенуПобочногоВыпуска(
				Форма.Объект, Форма.Валюта, СтруктураДействий);
		КонецЕсли;
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтрокаТабличнойЧасти, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

Функция ИспользуетсяВариантОбеспечения(ДанныеСтроки) Экспорт

	Если ДанныеСтроки.Производится
		И ДанныеСтроки.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.НеТребуется") Тогда
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецОбласти

